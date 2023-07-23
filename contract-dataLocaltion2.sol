// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

contract C {
    uint[4] public x;

    //状态变量不允许memory
    // uint[3] memory public y;

    function f() public {
        g(x);
        h(x);
    }

    //将x在memory中copy一份
    function g(uint[4] memory y) internal pure {
        y[2] = 3;
    }

    //将x的引用copy给y
    function h(uint[4] storage y) internal {
        y[3] = 4;
    }
}