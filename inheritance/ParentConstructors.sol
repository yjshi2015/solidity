// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
有2种方式调用父合约的构造函数，且父合约构造函数的初始化顺序跟继承顺序保持一致：基础合约在前，衍生合约在后
*/

contract S {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

contract T {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

//方式一：向父级构造函数传入指定参数
//构造函数初始化顺序： S, T, U，即按照继承顺序进行初始化
contract U is S("s"), T("t"){}


//方式二：向父级构造函数传入动态参数，类似于函数修改器modifier
contract V is S, T {    
    constructor(string memory _name, string memory _text) S(_name) T(_text) {}
}

//混搭
contract VV is S("s"), T {
    constructor(string memory _text) T(_text) {}
}