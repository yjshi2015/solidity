// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
A calls B, sends 100 wei
        B calls C, sends 50 wei
A ----> B ----> C
                msg.sender = B
                msg.value = 50
                execute code on C's state variables
                use ETH in C
普通调用如上，这是常规的方式，合约C按照自己的逻辑发生状态变更。

A calls B, sends 100 wei
        B delegatecall C
A  ---> B  ---> C
                msg.sender = A
                msg.value = 100
                execute code on B's state variables
                use ETH in B
委托调用如上，B委托C执行了一部分逻辑，来修改自己（B）的状态，所有的变更都在B合约身上，C合约只是执行了
更新后的逻辑，C并未做任何改变。
委托调用设计的初衷：由于合约在区块链上部署后就无法进行修改，所以如果要升级代码基本不可能，通过委托调用
的方式，曲线救国来升级B的代码。
*/

contract TestContract {
    //被调用合约的结构布局必须和委托合约一致
    //如果有新增的状态变量，要按照原变量顺序添加到最后
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) external payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract DelegateCall {
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _test, uint _num) external payable {
        /*
        委托调用方式1，容易发生拼写错误
        _test.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
        */

        //委托调用方式2
        (bool success, ) = _test.delegatecall(
             abi.encodeWithSelector(TestContract.setVars.selector, _num)
        );
        
        require(success, "delegatecall failed, wakaka~");
    }
}