// pragma solidity >=0.6.2 <0.9.0;
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
contract Test {
    uint public x;
    // This function is called for all messages sent to
    // this contract (there is no other function).
    // Sending Ether to this contract will cause an exception,
    // because the fallback function does not have the `payable`
    // modifier.
    // fallback函数未用payable修饰，因此无法向该合约转账
    fallback() external { x = 1; }
}

contract TestPayable {
    uint public x;
    uint public y;
    // This function is called for all messages sent to
    // this contract, except plain Ether transfers
    // (there is no other function except the receive function).
    // Any call with non-empty calldata to this contract will execute
    // the fallback function (even if Ether is sent along with the call).
    fallback() external payable { x = 1; y = msg.value; }

    // This function is called for plain Ether transfers, i.e.
    // for every call with empty calldata.
    receive() external payable { x = 2; y = msg.value; }
}

contract Caller {

    //使该合约可以接收以太币
    receive() external payable {
        emit logAddress(msg.sender);
    }

    //转账报错，原因：自己给自己转账，并不是Remix账户给Caller合约转账！因为这个转账操作是在Caller合约中
    //进行的，所以扣减的是Caller账户的余额，但Caller合约没有初始以太币，所以执行总是报错！
    function transferThis(uint amount) public {
        payable(address(this)).transfer(amount);
    }

    //接收Remix账户的转账
    function deposit() external payable {}

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function callTest(Test test) public returns (bool) {
        (bool success,) = address(test).call(abi.encodeWithSignature("nonExistingFunction()"));
        require(success);
        // results in test.x becoming == 1.

        // address(test) will not allow to call ``send`` directly, since ``test`` has no payable
        // fallback function.
        // It has to be converted to the ``address payable`` type to even allow calling ``send`` on it.
        address payable testPayable = payable(address(test));

        // If someone sends Ether to that contract,
        // the transfer will fail, i.e. this returns false here.
        return testPayable.send(2 ether);
    }

    function callTestPayable(TestPayable test) public returns (bool) {
        (bool success,) = address(test).call(abi.encodeWithSignature("nonExistingFunction()"));
        emit logMessage("step 1");
        require(success);
        // results in test.x becoming == 1 and test.y becoming 0.
        (success,) = address(test).call{value: 1 ether}(abi.encodeWithSignature("nonExistingFunction()"));
        emit logMessage("step 2");
        require(success);
        // results in test.x becoming == 1 and test.y becoming 1.

        // If someone sends Ether to that contract, the receive function in TestPayable will be called.
        // Since that function writes to storage, it takes more gas than is available with a
        // simple ``send`` or ``transfer``. Because of that, we have to use a low-level call.
        (success,) = address(test).call{value: 2 ether}("");
        emit logMessage("step 3");
        require(success);
        // results in test.x becoming == 2 and test.y becoming 2 ether.

        return success;
    }

    event logBalance(uint);
    event logAddress(address);
    event logMessage(string);
}