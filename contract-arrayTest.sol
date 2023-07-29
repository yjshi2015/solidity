// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.8;

contract ArrayTest {

    uint[] public x;

    /*
    默认情况下，x数组的长度为0，也就是说没有默认零值！！！
    */
    function getLen() public view returns (uint) {
        return x.length;
    }

    /* 
    数组x有个默认的0值元素，在执行push()函数后，是否又添加了一个默认元素？

    答案：否，首先默认元素并不存在，直接访问默认元素会失败；执行push（）后，添加了默认的0值元素
    */
    function testPush() external returns (uint) {
        return  x.push();
    }


    /*
    x.push() = 66 等价于 x.push(66);
    */
    function testPush1() external {
        x.push() = 66;
    }

    /*
    动态大小的字节数组，这里的“动态”指的是 数组长度不固定，但每个元素均为1字节
    */
    bytes public myBytes;
    function bytesFun() public {
        myBytes = new bytes(2);
        myBytes.push(0x12);
        myBytes.push(0x34);
        myBytes.push(0x56);
        myBytes.push(0x78);
        myBytes.push(0x90);
        myBytes.push(0x91);
        
        //下行代码不生效，因为要求每个元素都是1个字节
        // myBytes.push(0x1234);
        
    }

    //固定大小字节数组，这里的“固定”值得是每个元素的长度是固定的
    bytes32[] public  myBytesArray;
    function bytesFun2() public {
        myBytesArray = new bytes32[](3);
        myBytesArray[0] = hex"1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef";
        myBytesArray[1] = hex"abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890";
        myBytesArray[2] = hex"7890abcdef1234567890abcdef1234567890abcdef1234567890abcdef123456";

    }

    //定义1个长度为2的静态数组
    // uint256[2] memory staticArr = new uint256[2];

    //定义1个初始长度为2的动态数组
    uint[] dynamicArr = new uint[](2);

    //定义1个长度为2的多维动态数组
    // uint256[][2] dynamicMultiArr = new uint256[][2];
    uint[][2] dynamicMultiArr;

    function testArr() public {
        uint256[2] memory staticArr;
        staticArr[0] = 0;
        staticArr[1] = 1;
        //如下赋值将编译错误：TypeError: Out of bounds array access.因为只有2个元素
        // staticArr[2] = 2;

        //定义1个初始长度为2的动态数组
        // uint[] memory dynamicArr = new uint[](2);
        dynamicArr[0] = 0;
        dynamicArr[1] = 1;
        //动态添加第3个元素
        dynamicArr.push(2);

        //定义1个长度为2的多维动态数组
        dynamicMultiArr[0].push(1);
        dynamicMultiArr[1].push(2);
        dynamicMultiArr[1].push(3);

        //或者用如下方式赋值
        // dynamicMultiArr[0] = new uint256[](1);
        // dynamicMultiArr[0][0] = 1;
        // dynamicMultiArr[1] = new uint256[](2);
        // dynamicMultiArr[1][0] = 1;
        // dynamicMultiArr[1][1] = 2;

        //动态多维数组不能直接使用花括号{}一次性赋值。这是因为在Solidity中，动态数组的长度是可变的，而静态数组的长度是固定的。
        // dynamicMultiArr = {{1}, {1,2}};
    }
}