// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
函数调用的方式：
1、通过合约实例.function的方式（常见）
    1.1、将合约实例的地址转为指定合约类型，如下2种。
2、通过合约名.function的方式（内部函数，常见于继承场景中）
*/
contract CallTestContract {

    //指定TestContract类型的address地址类型参数
    function setX(TestContract testAddress, uint _x) external {
        testAddress.setX(_x);
    }
    
    //指定address地址（需要调用者传入正确的合约类型地址）
    function setX2(address testAddress, uint _x) external {
        TestContract(testAddress).setX(_x);
    }

    function getX(address testAddress) external view returns (uint x) {
        x = TestContract(testAddress).getX();
    }

    //将Remix账户的余额发送到CallTestContract合约，再由CallTestContract合约发送到TestContract合约？？？
    function setXandSendEhter(address testAddress, uint _x) external payable {
        //通过{value：msg.value}完成了以太币的转账，在TestContract合约中的value变量只是又存储了一份余额
        //的数值，余额的一种表现形式，也可以用valueX/valueY/valueZ这样的变量单独存储余额，但并不是说这些
        //字段就是该合约的余额
        TestContract(testAddress).setXandReceiveEther{value : msg.value}(_x);
    }

    function getXandValue(address testAddress) external view returns (uint x, uint value) {
        (x, value) = TestContract(testAddress).getXandValue();
    }

}

contract TestContract {
    uint public x;
    uint public value = 123;

    function setX(uint _x) external {
        x = _x;
    }

    function getX() external view returns (uint) {
        return x;
    }

    function setXandReceiveEther(uint _x) external payable {
        x = _x;
        value = msg.value;
    }

    function getXandValue() external view returns (uint, uint) {
        return (x, value);
    }
}