// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract C {
    uint index;

    function f() public pure returns (uint, bool, uint) {
        return (7, true, 2);
    }

    function g() public {
        // Variables declared with type and assigned from the returned tuple,
        // not all elements have to be specified (but the number must match).
        (uint x, , uint y) = f();

        /*
        数值交换的小技巧！高效！
        */
        // Common trick to swap values -- does not work for non-value storage types.
        assert(x == 7);
        assert(y == 2);
        (x, y) = (y, x);
        assert(x == 2);
        assert(y == 7);
        
        // Components can be left out (also for variable declarations).
        (index, , ) = f(); // Sets the index to 7
    }
}