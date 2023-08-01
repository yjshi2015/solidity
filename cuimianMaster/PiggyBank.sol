// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
小猪存钱罐：可以接收别人或自己传入的以太币，也可以由owner取出所有余额，同时销毁该合约实例
*/
contract PiggyBank {
    address public owner = msg.sender;
    event Deposit(address depositor, uint amount);
    event Withdraw(address beneficor, uint amount);

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw() external {
        require(msg.sender == owner, "not owner");
        emit Withdraw(msg.sender, address(this).balance);
        selfdestruct(payable(msg.sender));
    }
}