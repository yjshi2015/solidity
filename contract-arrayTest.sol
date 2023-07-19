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

}