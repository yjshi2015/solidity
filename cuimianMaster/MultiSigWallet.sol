// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/*
一笔交易要由N个owner中的M人(逻辑)签名后，才能转账成功
Note: gas费用是从Remix账户扣除的（谁发起谁付交易费），转账金额是从合约账户扣除的
*/
contract MultiSigWallet {
    //接收事件
    event Deposit(address indexed sender, uint amount);
    event Submit(uint indexed txId);
    event Approve(address indexed owner, uint indexed txId);
    event Revoke(address indexed owner, uint indexed  txId);
    event Execute(uint indexed txId);

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    address[] public owners;
    //某个地址是否属于owner，如果该值在map中不存在，则value默认为false
    mapping(address => bool) public isOwner;
    uint public required;

    //以索引为txId
    Transaction[] public transactions;
    //某笔交易某个owner是否已签名
    mapping(uint => mapping(address => bool)) public approvedMap;

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "owner is required");
        require(_required > 0 && _required <= _owners.length, "invalid required number of owners");

        for (uint i; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "owner is 0 address");
            isOwner[owner] = true;
            owners.push(owner);
        }

        require(owners.length >= _required, "some of owner is invalid");
        required = _required;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    modifier onlyOwner() {
        require(isOwner[msg.sender], "only owner can submit transaction");
        _;
    }

    modifier txIdExist(uint _txId) {
        require(_txId < transactions.length && _txId >= 0, "transaction is not exist");
        _;
    }

    modifier notApproved(uint _txId) {
        require(!approvedMap[_txId][msg.sender], "this owner already approved");
        _;
    }

    modifier notExecuted(uint _txId) {
        require(!transactions[_txId].executed, "this tx already executed");
        _;
    }

    //产生一笔交易，push到数组中
    function submit(address _to, uint _value) external onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value : _value,
            data : abi.encodeWithSignature("notExistFun(string)", "haha"),
            executed : false
        }));
        emit Submit(transactions.length - 1);
    }

    //某个owner批准交易
    function approve(uint _txId) external 
        onlyOwner 
        txIdExist(_txId) 
        notApproved(_txId) 
        notExecuted(_txId) 
    {
        approvedMap[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId);
    }

    function _getApprovalCount(uint _txId) private view returns (uint count) {
        for(uint i; i < owners.length; i++) {
            if (approvedMap[_txId][owners[i]]) {
                ++count;
            }
        }
    }

    //所有人签名后，发起转账 17617
    function execute(uint _txId) external txIdExist(_txId) notExecuted(_txId) {
        require(_getApprovalCount(_txId) >= required, "approvals < required");
        Transaction storage transaction = transactions[_txId];
        //先变更状态，再执行转账操作，防止安全漏洞
        transaction.executed = true;

        (bool success, ) = transaction.to.call{value : transaction.value}(transaction.data);
        require(success, "tx executed failed");

        emit Execute(_txId);
    }

    //撤销签名
    function revoke(uint _txId) external onlyOwner txIdExist(_txId) notExecuted(_txId) {
        require(approvedMap[_txId][msg.sender], "tx not approved");
        //逻辑签名
        approvedMap[_txId][msg.sender] = false;
        emit Revoke(msg.sender, _txId);
    }
}