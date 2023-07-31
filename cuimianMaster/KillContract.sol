// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KillContract {

    //向指定合约转入以太币的方法
    //方法一、只有fallback（没有receive、constructor、deposit函数）
    //在Remix面板中指定要转入的金额，在Low Level interactions中点击Transaction即可转入
    // fallback() external payable {}

    //方法二、操作方式如上
    // receive() external payable {}

    //方法三、在Remix中deploy该合约时指定Value，点击deploy，即可向该合约转入以太币
    //Note：这种方式转入以太币速度很慢，要等待10s左右才能入账。貌似是分为deploy和转账交易
    //2个阶段
    constructor() payable {}

    //方法四、自定义payable函数，在Remix中填入value，然后调用该方法即可
    // function anyFun() payable external {}

    //自毁时接收方即使没有接收以太币的函数，也能强制将以太币转入指定地址
    function kill() external {
        selfdestruct(payable(msg.sender));
    }

    function testCall() external pure returns (uint) {
        return 123;
    }
}

//该合约本身无法接收以太币，但是selfdestruct函数的接收方，能够在目标合约销毁时强制接收以太币
//不要也的要，要不然以太币就丢失了
contract Helper {

    //通过主动调用，将以太币转入到Helper合约
    function doKill(KillContract _kill) public {
        _kill.kill();
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}