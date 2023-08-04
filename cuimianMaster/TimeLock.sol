// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeLock {
    error TxAlreadyExist(bytes32 txId);
    error TimestampNotInRangeError(uint timestamp, uint blocktimestamp);
    error TxFailedError(bytes32 txId);
    error NotQueuedError(bytes32 txId);
    error TimestampExpiredError();
    error NotExistOrCancled(bytes32 txId);

    event Execute(bytes32 txId, address target, uint value, string func, bytes data);
    event TaskInQueue(bytes32 indexed txId, address indexed target, uint value, string func, bytes data, uint timestamp);
    event Cancle(bytes32 indexed txId);


    uint public MIN_DELAY = 10;
    uint public MAX_DELAY = 1000;
    uint public GRACE_PER100 = 1000;

    address public owner;
    //美其名曰交易队列，明明是map映射
    mapping (bytes32 => bool) queued;
    
    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    modifier onlyOwner() {
        require(msg.sender == owner, "Not Owner Error");
        _;
    }

    function getTxId(
        address _target,        //目标合约的地址
        uint _value,            //可用来转入以太币
        string calldata _func,  //目标函数名
        bytes calldata _params,   //函数调用的参数
        uint _timestamp ) private pure returns (bytes32) 
    {
        return keccak256(abi.encode(_target, _value, _func, _params, _timestamp));
    }

    function queue(
        address _target,        //目标合约的地址
        uint _value,            //可用来转入以太币
        string calldata _func,  //目标函数名
        bytes calldata _params,   //函数调用的参数
        uint _timestamp         //交易执行时间
        ) external onlyOwner
    {
        bytes32 txId = getTxId(_target, _value, _func, _params, _timestamp);
        if (queued[txId]) {
            revert TxAlreadyExist(txId);
        }

        if (_timestamp < block.timestamp + MIN_DELAY || _timestamp > block.timestamp + MAX_DELAY) {
            revert TimestampNotInRangeError(_timestamp, block.timestamp);
        }

        queued[txId] = true;

        emit TaskInQueue(txId, _target, _value, _func, _params, _timestamp);
    }

    function execute(
        address _target,        //目标合约的地址
        uint _value,            //可用来转入以太币
        string calldata _func,  //目标函数名名
        bytes calldata _params,   //函数调用的参数
        uint _timestamp         //交易执行时间
        ) payable external onlyOwner returns (bytes memory)
    {
        bytes32 txId = getTxId(_target, _value, _func, _params, _timestamp);
        if (!queued[txId]) {
            revert NotQueuedError(txId);
        }
        
        if (block.timestamp < _timestamp || block.timestamp > _timestamp + GRACE_PER100) {
            revert TimestampExpiredError();
        }

        queued[txId] = false;

        bytes memory data;
        //长度>0，说明调用的不是fallback函数
        if (bytes(_func).length > 0) {
            data = abi.encodePacked(bytes4(keccak256(bytes(_func))), _params);
        } else {
            data = _params;
        }

        (bool ok, bytes memory res) = _target.call{value: _value}(data);
        if (!ok) {
            revert TxFailedError(txId);
        }

        emit Execute(txId, _target, _value, _func, _params);
        return res;
    }

    function cancle(bytes32 txId) external {
        if (queued[txId]) {
            revert NotExistOrCancled(txId);
        }

        queued[txId] = false;
        
        emit Cancle(txId);
    }
}