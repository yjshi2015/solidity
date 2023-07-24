// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract VendingMachine {
    address public owner;
    //这种方式携带错误信息，会增加gas
    // error Unauthorized(string);

    //建议采用这种方式，通过error的名字来体现错误信息
    error Unauthorized();

    constructor () {
        owner = msg.sender;
    }

    function buy(uint amount) public payable {
        if (amount > msg.value / 2 ether)
            revert("Not enough Ether provided.");
        // Alternative way to do it:
        require(
            amount <= msg.value / 2 ether,
            "Too enough Ether provided."
        );
        // Perform the purchase.
    }

    function withdraw() public {
        if (msg.sender != owner)
            revert Unauthorized();

        payable(msg.sender).transfer(address(this).balance);
    }
}