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

    //声明字节数组，并为其赋值
    function testType() public returns (uint) {
        myBytes = new bytes(0);
        myBytes.push(0x12);
        myBytes.push(0x34);
        return myBytes.length;
    }

    /*
    // mapping不能作为返回值
    function testReturn() public returns (mapping(uint => bool) memory) {
       // to do something 
    }
    */

    struct Student {
        uint index;
        string name;
    }

    //结构体可以作为出参
    function testReturn() public pure returns (Student memory) {
        Student memory student = Student({index: 1, name: "zhangsan"});
        return student;
    }
}