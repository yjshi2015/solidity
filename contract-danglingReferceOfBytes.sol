// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

// This will report a warning
contract C {
    bytes public x = "012345678901234567890123456789";

    /*
    默认情况下，字节数组的长度为30
    */
    function getLen() external view returns (uint) {
        return x.length;
    }

    /*
    发生悬空引用的情况下，字节数组的长度变得混乱，竟成了160
    */
    function test() external returns(uint) {
        (x.push(), x.push()) = (0x01, 0x02);
        return x.length;
    }
}