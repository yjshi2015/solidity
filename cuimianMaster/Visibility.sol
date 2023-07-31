// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
visibility
private - only inside contract
internal - only inside contract and child contrqcts
external - only from outside contract
public - inside and outside contract

————————————————————
| A                 |
| private   pri()   |
| internal  inter() |
| public    pub()   |            <------------------- C
| external  ext()   |                pub() and ext()
————————————————————

————————————————————
| B is A            |
| inter()           |            <------------------ C
| pub()             |             
————————————————————
*/

// 字面量，合约外部定义，可以被所有合约使用
uint constant myUintLiteral = 1234;

contract VisibilityBase {
    // 字面量，合约内部定义，只能在合约内部使用
    uint constant myUintLiteral2 = 456;

    // storage位置的状态变量
    uint private x = 0;
    uint internal y = 1;

    //变量的可见性是没有external的！
    /*
    假如有一个变量的可见性是external，也就是不能在合约内部可见，那它为什么要定义在这个合约里呢？！
    但对于函数而言就不一样了，函数既可以有external，又可以有public，都支持外部调用，但两者又有本质
    不同。调用external函数时，在以太坊网络中进行的是外部交易调用（external transaction），即将函数
    的调用者和参数打包成一个交易，广播到以太坊网络中执行。而调用public函数时，既可以发生在合约内部，
    也可以发生在合约外部，当被外部合约调用时，solidity编译器会把参数打包成一个消息，发送到合约地址所
    在的以太坊网络节点中执行，这可以是任意一个节点，获取函数返回值或修改状态变量。如果发生了状态变更，
    则会生成新的区块，并将该区块发布到网络中。

    Note：message call的执行速度比外部交易要快，并且不产生gas费，但message call不支持支付以太币和
    和external可见性的函数
    */
    // uint external z = 2;
    uint public n = 3;


    function privateFun() private pure returns (uint) {
        return 0;
    }

    function internalFun() internal pure returns (uint) {
        return 0;
    }

    function externalFun() external pure returns (uint) {
        return 0;
    }

    function publicFun() public pure returns (uint) {
        return 0;
    }

    function examples() public view {
        x + y + n;

        privateFun();
        internalFun();
        publicFun();

        //外部调用的函数，不能内部调用，以下代码编译错误
        // externalFun();

        //可以通过this来实现外部调用，但这是一种曲线救国的方式，并且会产生gas费，如果有这样的
        //场景，可以直接将函数定义为public
        this.externalFun();
    }
}

contract VisibilityChild is VisibilityBase {
    function examples2() public view {
        // x;
        y + n;

        // privateFun();
        internalFun();
        publicFun();

        //不可以由子合约访问，也不可以由子合约override（都不能访问了还override啥？！）
        // externalFun();
    }
}