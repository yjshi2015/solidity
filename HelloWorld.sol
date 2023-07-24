// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

contract HelloWordl {
    string public myString = "hello world!";
    uint256 public myInt;

    function convertToBytes32(string memory input) public pure returns (bytes32) {
        bytes32 output = bytes32(0);
        assembly {
            output := mload(add(input, 32))
        }
        return output;
    }
}