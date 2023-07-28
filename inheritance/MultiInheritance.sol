// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
线性继承的order顺序非常重要，继承时要求把最基础的合约写在前面，例如
    X
  /  |
Y    |
  \  |
    Z

Contract Z is X,Y

    X
   / |
 Y   A
 |   |
 |   B
  \  /
    Z
Contract Z is X,Y,A,B 
*/

contract X {
    function foo() public pure virtual returns (string memory) {
        return "x";
    }

    function bar() public pure virtual returns (string memory) {
        return "x";
    }

    function x() public pure returns (string memory) {
        return "x";
    }
}

contract Y is X {
    function foo() public pure virtual override returns (string memory) {
        return "Y";
    }

    function bar() public pure virtual override returns (string memory) {
        return "Y";
    }

    function y() public pure returns (string memory) {
        return "Y";
    }
}

/*
继承order顺序，要先把最基础的放在前面，衍生的放在后面。如果按照contract Z is Y , X，则会报如下错误：
TypeError: Linearization of inheritance graph impossible

另：
Z合约不仅有foo和bar函数，也有X()和y()函数
*/
contract Z is X , Y{

    //这个地方覆盖也要写上X,Y，表明覆盖这2个合约的同名函数
    function foo() public pure override(X, Y) returns (string memory) {
        return "Z";
    }

    function bar() public pure override (X, Y) returns (string memory) {
        return "Z";
    }
}