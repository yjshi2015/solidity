// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// require assert revert
// gas refund(gas费退还？？？), state updates are reverted
// custom error - save gas
contract ErrorDemo {
    function testRequire(uint _i) public pure {
        require(_i < 10000, "i is too big");
    }

    function testRevert(uint _i) public pure {
        if (_i > 10000) {
            revert(" i > 10000");
        }
    }

    uint public num = 123;
    function testAssert() public view {
        assert(num == 123);
    }

    error MyError();
    function testCustomError(uint _i) public pure {
        if (_i > 10000) {
            revert MyError();
        }
    }

    error MyError2(address caller, uint i);
    function testCustomError2(uint _i) public view {
        if (_i > 10000) {
            revert MyError2(msg.sender, _i);
        }
    }
}