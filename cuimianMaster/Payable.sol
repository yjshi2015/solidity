// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Payable {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    //可通过Remix -> deploy&run transaction ->指定value -> transaction往该合约转入以太币
    receive() external payable {}

    //可直接调用deposit函数向该合约转入以太币
    function deposit() external payable {}

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}