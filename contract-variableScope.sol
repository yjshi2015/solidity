// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;
contract C {

    /*
    this examples will compile without warnings, since the two variables have the same name but disjoint scopes.
    */
    function minimalScoping() pure public {
        {
            uint same;
            same = 1;
        }

        {
            uint same;
            same = 3;
        }
    }


    /*
     the first assignment to x will actually assign the outer and not the inner variable. 
     In any case, you will get a warning about the outer variable being shadowed.
    */
    function f() pure public returns (uint) {
        uint x = 1;
        {
            x = 2; // this will assign to the outer variable
            uint x;
        }
        return x; // x has value 2
    }
}