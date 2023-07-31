// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SenderEther {

    receive() external payable {}

    //如果发生异常，比如接受者拒收或者gas费不够，则抛出异常，回滚状态
    function sendViaTransfer(address _to, uint amount) public {
        payable(_to).transfer(amount);
    }

    //如果发生异常，不抛异常，但返回false
    function sendViaSend(address _to, uint amount) public {
        bool success = payable(_to).send(amount);
        require(success, "send failed");
    }

    //会携带所有剩余gas（带上全部家底），会返回2个值，bool 和 bytes
    function sendViaCall(address _to, uint amount) public {
        (bool success, bytes memory datas) =_to.call{value: amount}("");
        require(success, "call failed");
    }
}

contract ReceiveEther {
    event Log(uint amount, uint gas);

    receive() external payable {
        emit Log(msg.value, gasleft());
    }
}