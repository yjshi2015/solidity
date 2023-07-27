// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

//函数重载，函数名相同，参数不同
contract A {
    function f(uint value) public pure returns (uint out) {
        out = value;
    }

    function f(uint value, bool really) public pure returns (uint out) {
        if (really)
            out = value;
    }

    /*重载函数f1编译不通过
    Both f1 function overloads above end up accepting the address type for the ABI although they are considered different inside Solidity.
    因为f1函数接收ABI的地址类型，尽管他们的参数在solidity内部是不同的
    function f1(B value) public pure returns (B out) {
        out = value;
    }

    function f1(address value) public pure returns (address out) {
        out = value;
    }
    */

    /*
    调用 f(50) 会导致类型错误，因为 50 既可以被隐式转换为 uint8 也可以被隐式转换为 uint256。 
    另一方面，调用 f(256) 则会解析为 f(uint256) 重载， 因为 256 不能隐式转换为 uint8。
    */
    function f3(uint8 val) public pure returns (uint8 out) {
        out = val;
    }

    function f3(uint256 val) public pure returns (uint256 out) {
        out = val;
    }
}


contract B {
}