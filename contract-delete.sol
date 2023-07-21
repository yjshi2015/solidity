// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract DeleteExample {
    uint public data;
    uint[] public dataArray;
    uint[3] public staticArray = [1, 2, 3];

    event execLog(uint);

    function f() public {
        uint x = data;
        delete x; // sets x to 0, does not affect data
        delete data; // sets data to 0, does not affect x
    }

    function f2() public view returns (uint) {
        return dataArray.length;
    }

    /*
    变长数组删除后，变成长度为0的数组
    */
    function f3() public {
        dataArray = [4, 5, 6];
        emit execLog(dataArray.length);
        delete dataArray; // this sets dataArray.length to zero, but as uint[] is a complex object, also
        // y is affected which is an alias to the storage object
        // On the other hand: "delete y" is not valid, as assignments to local variables
        // referencing storage objects can only be made from existing storage objects.
        emit execLog(dataArray.length);
    }

    /*
    定长数组删除后，长度不变，所有元素都赋值为初始值！
    */
    function f4() public returns (uint) {
        delete staticArray;
        return staticArray.length;
    }
}