// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract C {
    // The data location of x is storage.
    // This is the only place where the
    // data location can be omitted.
    uint[] public x;

    // The data location of memoryArray is memory.
    function f(uint[] memory memoryArray) public {
        x = memoryArray; // works, copies the whole array to storage
        uint[] storage y = x; // works, assigns a pointer, data location of y is storage
        y[7]; // fine, returns the 8th element
        y.pop(); // fine, modifies x through y
        delete x; // fine, clears the array, also modifies y
        // The following does not work; it would need to create a new temporary /
        // unnamed array in storage, but storage is "statically" allocated:
        // y = memoryArray;
        // Similarly, "delete y" is not valid, as assignments to local variables
        // referencing storage objects can only be made from existing storage objects.
        // It would "reset" the pointer, but there is no sensible location it could point to.
        // For more details see the documentation of the "delete" operator.
        // delete y;
        g(x); // calls g, handing over a reference to x
        h(x); // calls h and creates an independent, temporary copy in memory
    }

    /*
    以下函数说明：storageArray存储的是x的指针
    局部变量中用storage修饰，这样的变量只是一个指针，仍指向storage中的变量
    */
    function f2(uint[] memory memoryArray) public {
        // 将内存中的数组copy给storage中的x
        x = memoryArray;
        x[0] = 4;
        // 把x的指针赋给storageArray
        uint[] storage storageArray = x;
        // 通过storageArray指针再把x[0]由4改为5
        storageArray[0] = 5;
    }

    function f3(uint[] memory memoryArray) public {
        /* 
        it doesnot work
        TypeError: Type uint256[] memory is not implicitly convertible to expected type uint256[] storage pointer.
        */

        // uint[] storage storageArr = memoryArray;
    }

    //入参memoryArray的指针赋给了locallArr，memoryArray的值copy给了x，因此localArr和x在两个不同的变量区域
    function f4(uint[] memory memoryArray) public {
        uint[] memory localArr = memoryArray;
        x = memoryArray;

        x[0] = 4;
        localArr[0] = 5;
        assert(x[0] != localArr[0]);
    }

    function g(uint[] storage) internal pure {}
    function h(uint[] memory) public pure {}
}