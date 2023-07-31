// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TestContract {
    string public message;
    uint public x;

    event Log(string message);

    fallback() external payable {
        emit Log("fallback was called");
    }

    receive() external payable {
        emit Log("receive was called");
    }

    function foo(string memory _message, uint _x) external payable returns (bool, uint) {
        message = _message;
        x = _x;
        return (true, 999);
    }
}

contract Call {
    bytes public data;

    /*
    ①该方法调用可能会失败，原因在于call调用携带有data数据，所以会调用目标函数的fallback函数（即使目标函数
    有receive方法），T所以目标合约的fallback函数必须要用payable修饰！
 
    ②该函数可以接收以太币，同时立即马上将接收到的以太币转发给_test地址账户，如果有剩余，则存在该合约账户中

    ③call方法调用有点类似于Java的反射调用，只要知道了目标对象的地址和函数签名，就可以发起调用，非常灵活
    */
    function callFoo(address _test) external payable {
        (bool success, bytes memory _data) = _test.call{value:1}(
            abi.encodeWithSignature(
                "foo(string, uint256)", "call foo", 123
            )
        );
        require(success, "callfoo failed");
        data = _data;
    }

    function callDoesNotExist(address _test) public {
        (bool success, ) = _test.call(abi.encodeWithSignature("doesNotExist()"));
        require(success);
    }


}