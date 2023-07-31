// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Math {
    function max(uint x, uint y) internal pure returns (uint) {
        return x > y ? x : y;
    }
}

/*
库函数类似于Java中的工具类
*/
library ArrayTool {
    error DoesNotExist();

    function findIndex(uint[] memory arr, uint target) internal pure returns (uint) {
        for (uint i=0; i<arr.length; i++) {
            if(arr[i] == target) {
                return i;
            }
        }
        revert DoesNotExist();
    }
}

contract Test {
    function testMax(uint x, uint y) external pure returns (uint) {
        return Math.max(x, y);
    }
}

contract TestArray {
    using ArrayTool for uint[];

    uint[] public arr = [1, 2, 3, 4, 5, 6];

    function testFind(uint _target) external view returns (uint) {
        //常规调用方式
        // return ArrayTool.findIndex(arr, _target);

        //将library中函数的第一个参数作为对象，执行该对象在library中的函数，传入第二个参数作为参数
        return arr.findIndex(_target);
    }
}