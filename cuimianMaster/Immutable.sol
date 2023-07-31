// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Immutable {

    uint public x;

    //变量 gas 234981, transaction 204375，execution 141131
    // address public owner = msg.sender;

    //常量 gas 208806, transaction 181614, execution 119026
    //常量节省gas费
    //address public immutable owner = msg.sender;

    //constant必须在编译时赋值, immutable可以在部署的时候赋值
    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }

    function foo() external {
        require(msg.sender == owner);
        x += 1;
    }
}