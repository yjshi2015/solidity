// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
如果向该合约转账，fallback和receive这2个函数都可以接受以太币，具体区别在于msg.data，如果msg.data有值，
则调用fallback，值为空则调用receive函数
*/
contract Fallback {

    event Log(string func, address sender, uint value, bytes data);

    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }


    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }
    
}