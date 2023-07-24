// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
Note：
remix中在call function时，只要在value中填入了值，就会从当前账户余额中转移value给到指定的地址，不管有没有显式的转账操作！
*/
contract RequireAndAssertDemo {

    // 通过event来打印日志
    event logUint(uint);
    event logAddress(address);

    //如下代码donot work，因为localVar本身就是storage存储，所以不用再进行强调（搞不明白强调的话为什么还报错）
    // uint storage public localVar = 1;

    uint public localVar = 1;

    //如果不满足条件，状态变量localVar的值会回滚。
    function fun1(uint arg) public {
        localVar = arg;
        require(arg < 100, "this arg is too big");
        //这里不含有错误信息，所以返回的错误信息并不明确
        require(arg < 50);
    }

    //不满足条件，状态变量localVar的值会回滚。
    function fun2(uint arg) public {
        localVar = arg;
        uint x = arg * 100;
        assert(x < 100);
    }


    function fun3() public payable  {
        emit logAddress(msg.sender);
        emit logUint(msg.value);

        //当前合约地址 0x43D218197E8c5FBC0527769821503660861c7045
        emit logAddress(address(this));
        uint balanceBeforeTransfer = address(this).balance;
        //当前账户的余额
        emit logUint(balanceBeforeTransfer);
    }

    //
    function funTrans(uint amount) public payable {
        require(amount > 0, "invalid transfer amount");
        address payable contractAddress = payable(address(this));
        //transfer方法适合简单的转账,gas费较低，为2300
        contractAddress.transfer(amount);
    }

    function funCall(uint amount) public payable {
        require(amount > 0, "invalid call amount");
        //call方法更通用，可以传多个参数；gas费较高，为2300的倍数；返回值为多元数组，可以根据返回结果进行更精细的处理
        (bool success,) = address(this).call{value: amount}("");
        require(success, "call failed");
    }

    function sendHalf(address payable addr) public payable returns (uint balance) {
        emit logAddress(msg.sender);
        //要转账的金额
        emit logUint(msg.value);
        require(msg.value % 2 == 0, "Even value required.");

        uint balanceBeforeTransfer = address(this).balance;
        //当前账户的余额 0x56a2777e796eF23399e9E1d791E1A0410a75E31b
        emit logUint(balanceBeforeTransfer);

        addr.transfer(msg.value / 2);
        // 由于转账失败后抛出异常并且不能在这里回调，
        // 因此我们应该没有办法仍然有一半的钱。
        assert(address(this).balance == balanceBeforeTransfer - msg.value / 2);
        //当前账户的剩余余额
        emit logUint(address(this).balance);
        return address(this).balance;
    }
}