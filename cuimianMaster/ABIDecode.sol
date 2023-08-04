// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
abi.encode:               适合对参数进行编码；自动补齐
abi.encodePacked:         适合对参数进行编码，紧凑型编码；计算hash时会用到
abi.encodewithsignature:  适合对函数签名及参数进行编码；自动补齐
abi.encodeWithSelector:   适合对函数选择器及参数进行编码；自动补齐
*/
contract AbiDecode {

    struct MyStruct {
        string name;
        uint[2] nums;
    }

    //如果一个array或struct参数不需要修改，只读取，用calldata类型；否则用memory
    function encode(uint x, address addr, uint[] calldata arr, MyStruct calldata myStruct) 
        external pure returns (bytes memory) 
    {
        return abi.encode(x, addr, arr, myStruct);
    }

    function decode(bytes calldata data) 
        external pure returns (uint x, address addr, uint[] memory arr, MyStruct memory myStruct) 
    {
        (x, addr, arr, myStruct) = abi.decode(data, (uint, address, uint[], MyStruct));
    }
}