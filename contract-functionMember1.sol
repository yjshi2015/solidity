// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.4 <0.9.0;

/*
External (or public) functions have the following members:

.address returns the address of the contract of the function.

.selector returns the ABI function selector

.gas(uint) and .value(uint) : use {gas: ...} and {value: ...} to specify the amount of gas or the amount of wei sent to a function, respectively.
*/
contract Example {
    function f() public payable returns (bytes4) {
        assert(this.f.address == address(this));
        return this.f.selector;
    }

    function g() public {
        this.f{gas: 10, value: 800}();
    }
}