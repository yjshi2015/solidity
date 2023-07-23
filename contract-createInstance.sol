// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract D {
    uint public x;
    constructor(uint a) payable {
        x = a;
    }
}

contract C {
    D d = new D(4); // will be executed as part of C's constructor

    function createD(uint arg) public returns (uint){
        D newD = new D(arg);
        return newD.x();
    }

    /*
    {
	    "error": "Failed to decode output: Error: hex data is odd-length (argument=\"value\", value=\"0x0\", code=INVALID_ARGUMENT, version=bytes/5.7.0)"
    }
    why ???
    */
    function createAndEndowD(uint arg, uint amount) public payable returns (uint) {
        // Send ether along with the creation
        D newD = new D{value: amount}(arg);
        return newD.x();
    }
}