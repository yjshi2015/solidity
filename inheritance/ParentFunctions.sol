// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
calling parent functions
- direct
- super

   E
 /   \
F     G
 \   /
   H
*/

contract E {
    event Log(string message);

    function foo() public virtual {
        emit Log("E.foo");
    }

    function bar() public virtual {
        emit Log("E.bar");
    }
}

contract F is E {
    function foo() public virtual override {
        emit Log("F.foo");
        //用父合约名称调用函数
        E.foo();
    }

    function bar() public virtual override {
        emit Log("F.bar");
        //用super
        super.bar();
    }
}

contract G is E {
    function foo() public virtual override {
        emit Log("G.foo");
        //用父合约名称调用函数
        E.foo();
    }

    function bar() public virtual override {
        emit Log("G.bar");
        //用super
        super.bar();
    }
}

contract H is F, G {
    function foo() public override(F, G) {
        F.foo();
    }

    function bar() public override(F, G) {
        //这里的super会分别调用F和G合约的bar函数
        super.bar();
    }
}