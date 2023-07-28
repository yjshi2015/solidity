// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
@Note 子合约中不能声明父合约中的变量，也就是说只有function可以覆盖，state variable不可以覆盖
*/
contract Parent {
    uint x;
}

contract Child is Parent {
    //编译错误，不能覆盖父类中的状态变量
    // uint x;

    uint y;
}

/*
@Note 使用合约名调用函数，适用于在合约内部调用自身的函数，或者在合约外部通过合约地址调用函数
*/
contract MyContract {
    uint public myVariable;

    function myFunction() public {
        myVariable = 42;
    }
}

contract CallerContract is MyContract{
    MyContract public myContract;

    constructor() {
        myContract = new MyContract();
    }

    function callFunction() public {
        // 使用合约名调用函数
        MyContract.myFunction();

        // 使用合约实例调用函数
        myContract.myFunction();
    }
}


/*
@Note 对于多重继承，必须在 override 关键字后明确指定定义同一函数的基类合约。 换句话说，您必须指定所有定义同一函数的基类合约
*/
contract Base1 {
    function foo() virtual  public {}
}

contract Base2 {
    function foo() virtual public {}
}

contract Inherited is Base1, Base2 {
    // 派生自多个定义 foo() 函数的基类合约，
    // 所以我们必须明确地重载它
    function foo() public override(Base1, Base2) {} 
}


/*
@Note : 如果函数被定义在一个共同的基类合约中， 或者在一个共同的基类合约中有一个独特的函数已经重载了所有其他的函数， 则不需要明确的函数重载指定符。
*/
contract A { function f() public pure{} }
contract B is A {}
contract C is A {}
// 无需明确的重载
contract D is B, C {}