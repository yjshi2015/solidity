// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
contract C {
    function f(uint a, uint b) pure public returns (uint) {
        // This subtraction will wrap on underflow.
        unchecked { return a - b; }
    }
    function g(uint a, uint b) pure public returns (uint) {
        // This subtraction will revert on underflow.
        return a - b;
    }

    /*
    位移操作不做检查
    */
    function noCheck() public pure returns (uint){
        return type(uint256).max << 3;
    }


    /*
    乘除运算会检查是否溢出
    */
    function check() public pure returns (uint) {
        return type(uint256).max * 8;
    }

    function nagative() public pure returns (int) {
        int x = type(int).min;
        //这里会导致溢出，因为负数比正数多1个值
        //the negative range can hold one more value than the positive range.
        int y = -x;
        return  y;
    }
}