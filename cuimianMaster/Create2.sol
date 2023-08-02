// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
new     方法部署的合约地址是根据 工厂合约的地址 + 工厂合约的交易次数nonce 得出来的
create2 方法部署的合约地址是根据 工厂合约的地址 + salt + 被部署合约的机器码，因此create2方式部署
的合约地址可以被提前预测
*/

contract TestContract {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }
}


contract ContractFactory {
    event Deploy(address addr);

    //普通的new方法部署合约，每次的部署地址不一样，因为nonce不同
    function newDeploy() external {
        TestContract _contract = new TestContract(msg.sender);
        emit Deploy(address(_contract));
    }

    //create2同一个salt每次部署的合约地址是固定的，也就是说每个salt只能使用一次。除非新合约使用了selfdestruct函数，
    //0x999Ca47745dE07a3fcab7C9B887e57F9f74217D5
    function Create2Deploy(uint _salt) external {
        TestContract _contract = new TestContract{
            salt : bytes32(_salt)
        }(msg.sender);

        emit Deploy(address(_contract));
    }


    //手动计算编译地址
    function getAddress(bytes memory bytecode, uint _salt) public view returns (address) {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),           //固定值
                address(this),          //工厂合约地址
                _salt,                  //盐
                keccak256(bytecode)     //待部署合约的机器码
            ));

        return address(uint160(uint(hash)));
    }

    function getBytecode(address _owner) public pure returns (bytes memory) {
        bytes memory bytecode = type(TestContract).creationCode;
        //需要加上构造函数的参数
        return abi.encodePacked(bytecode, abi.encode(_owner));
    }
}