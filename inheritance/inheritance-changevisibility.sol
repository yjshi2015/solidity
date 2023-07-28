// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
重载函数改变父函数的可见性 和 可变性。
The overriding function may only change the visibility of the overridden function from external to public. 

The mutability may be changed to a more strict one following the order: nonpayable can be overridden by view and pure. view can be overridden 
by pure. payable is an exception and cannot be changed to any other mutability.
*/
contract Base {
    function foo() virtual external view {}
}

contract Middle is Base{}


contract Inherited is Middle {
    //改变函数的 可变性，从 view 到 pure
    function foo() virtual override external pure {}
}