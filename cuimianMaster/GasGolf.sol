// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GasGolf {
    // 1、start - 34290 gas
    // 2、use calldata - 32478 gas
    // 3、load state variables to memory - 32063 gas
    // 4、short circuit - 28944 gas
    // 5、loop increments - 28617 gas
    // 6、cache array length - 28516 gas
    // 7、load array elements to memory - 28493 gas

    uint public total;

    //[1,2,3,4,5,6]
    function calSum1(uint[] memory arr) public {
        for (uint i; i < arr.length; i += 1) {
            bool isEven = arr[i] % 2 == 0;
            bool isLessThan99 = arr[i] < 99;
            if (isEven && isLessThan99) {
                total += arr[i];
            }
        }
    }

    function calSum2(uint[] calldata arr) public {
        for (uint i; i < arr.length; i += 1) {
            bool isEven = arr[i] % 2 == 0;
            bool isLessThan99 = arr[i] < 99;
            if (isEven && isLessThan99) {
                total += arr[i];
            }
        }
    }

    function calSum3(uint[] calldata arr) public {
        uint _total;
        for (uint i; i < arr.length; i += 1) {
            bool isEven = arr[i] % 2 == 0;
            bool isLessThan99 = arr[i] < 99;
            if (isEven && isLessThan99) {
                _total += arr[i];
            }
        }
        total = _total;
    }

    function calSum4(uint[] calldata arr) public {
        uint _total;
        for (uint i; i < arr.length; i += 1) {
            // bool isEven = arr[i] % 2 == 0;
            // bool isLessThan99 = arr[i] < 99;
            if (arr[i] % 2 == 0 && arr[i] < 99) {
                _total += arr[i];
            }
        }
        total = _total;
    }

    function calSum5(uint[] calldata arr) public {
        uint _total;
        for (uint i; i < arr.length; ++i) {
            // bool isEven = arr[i] % 2 == 0;
            // bool isLessThan99 = arr[i] < 99;
            if (arr[i] % 2 == 0 && arr[i] < 99) {
                _total += arr[i];
            }
        }
        total = _total;
    }

    function calSum6(uint[] calldata arr) public {
        uint _total;
        uint len = arr.length;
        for (uint i; i < len; ++i) {
            // bool isEven = arr[i] % 2 == 0;
            // bool isLessThan99 = arr[i] < 99;
            if (arr[i] % 2 == 0 && arr[i] < 99) {
                _total += arr[i];
            }
        }
        total = _total;
    }

    function calSum7(uint[] calldata arr) public {
        uint _total;
        uint len = arr.length;
        for (uint i; i < len; ++i) {
            // bool isEven = arr[i] % 2 == 0;
            // bool isLessThan99 = arr[i] < 99;
            // if (arr[i] % 2 == 0 && arr[i] < 99) {
            uint element = arr[i];
            if (element % 2 == 0 && element < 99) {
                _total += arr[i];
            }
        }
        total = _total;
    }
}