// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
events是solidity日志的一种高级抽象，events内容作为交易log存储在链上（跟交易数据存储在一起），具有不可篡改性
*/
contract eventExample {

    //用indexed修饰的变量，可用于topic过滤，但一个事件最多有3个indexed过滤的topic
    event myEvent(uint indexed id, address indexed sender, string message);

    function triggerEvent(uint id, string memory message) public {
        emit myEvent(id, msg.sender, message);
    }
}