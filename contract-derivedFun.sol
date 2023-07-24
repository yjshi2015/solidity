// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract C {
    uint private data;

    function f(uint a) private pure returns(uint b) { return a + 1; }
    function setData(uint a) public { data = a; }
    function getData() public view returns(uint) { return data; }
    function compute(uint a, uint b) internal pure returns (uint) { return a + b; }
}

// This will not compile
contract D {
    function readData() public {
        C c = new C();
        // error: member `f` is not visible
        // uint local = c.f(7); 
        c.setData(3);
        uint local = c.getData();

        // error: member `compute` is not visible
        // local = c.compute(3, 5); 
    }
}

/*
E继承C
*/
contract E is C {
    function g() public pure returns (uint){
        // C c = new C();
        uint val = compute(3, 5); // access to internal member (from derived to parent contract)
        return val;
    }
}