// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;


/*
1、部署proxy和helper
2、调用helper的testContract1函数，生成testContract1的字节码
3、调用proxy的deploy方法，将步骤2的结果作为入参，得到proxy部署的testContract1合约地址
4、调用testContractd的owner方法，发现owner是proxy的地址（因为是proxy部署的该合约）
5、接下来修改testContract1的owner为“当前账户”的地址，而非proxy的合约地址
6、调用proxy的execute方法，_target为第3步得到的address，_data为helper的getCallData出参（入参为当前账户的地址！）
7、执行完毕后验证，发现testContract1的owner地址已修改
*/
contract TestContract1 {

    address public owner = msg.sender;

    function setOwner(address _owner) public {
        require(msg.sender == owner, "not owner!!!");
        owner = _owner;
    }
}

contract TestContract2 {
    address public owner = msg.sender;
    uint public value = msg.value;
    uint public x;
    uint public y;

    constructor(uint _x, uint _y) payable {
        x = _x;
        y = _y;
    }
}

contract Proxy {

    event Deploy(address);

    //fallback() external payable {}

    function deploy(bytes memory _code) external payable returns (address addr) {
        assembly {
            // create(v, p, n)
            // v = amount ETH to send
            // p = pointer in memory to start of code
            // n = size of code
            addr := create(callvalue(), add(_code, 0x20), mload(_code))
        }
        require(addr != address(0), "deploy faild");

        emit Deploy(addr);
    }

    /*
    通过Proxy合约调用testContract1的setOwner函数，将owner替换为当前账户的address（而非代理合约的address），
    这种机制有点类似于java的反射，即通过proxy执行target类的方法
    */
    function execute(address _target, bytes memory _data) external payable {
        (bool success, ) = _target.call{value: msg.value}(_data);
        require(success, "failed");
    }

}

contract helper {
    function getBytecode1() external pure  returns (bytes memory) {
        bytes memory bytecode = type(TestContract1).creationCode;
        return  bytecode;
    }

    function getBytecode2(uint _x, uint _y) external pure returns (bytes memory) {
        bytes memory bytecode = type(TestContract2).creationCode;
        return  abi.encodePacked(bytecode, abi.encode(_x, _y));
    }

    function getCalldata(address _owner) external pure returns (bytes memory) {
        return abi.encodeWithSignature("setOwner(address)", _owner);
    }
}