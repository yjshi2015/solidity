// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.12;

contract C {
    string s = "Storage";
    /*
    bytes to string : 
    bytes myBytes; 
    string myString = string(myBytes);

    string to bytes :
    string myString;
    bytes myBytes = bytes(myString);

    string 拼接：
    string.concat(a, b, c……);

    bytes 拼接：
    bytes.concat(a, b, c……);
    */
    function f(bytes calldata bc, string memory sm, bytes16 b) public view {
        string memory concatString = string.concat(s, string(bc), "Literal", sm);
        //1字节数组bytes的长度为什么要 +7 ？？？
        assert((bytes(s).length + bc.length + 7 + bytes(sm).length) == bytes(concatString).length);

        //16字节数组bytes16的长度为什么要 +2 ？？？
        bytes memory concatBytes = bytes.concat(bytes(s), bc, bc[:2], "Literal", bytes(sm), b);
        assert((bytes(s).length + bc.length + 2 + 7 + bytes(sm).length + b.length) == concatBytes.length);
    }
}