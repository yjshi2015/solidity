// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

contract HelloWordl {
    string public myString = "hello world!";
    //只能在当前合约及子合约中访问
    uint256 internal myInt;
    //只能在当前合约中访问，其子类不可访问
    bytes private myBytes;


    function convertToBytes32(string memory input) public pure returns (bytes32) {
        bytes32 output = bytes32(0);
        assembly {
            output := mload(add(input, 32))
        }
        return output;
    }
}