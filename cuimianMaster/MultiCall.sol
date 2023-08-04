// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/*

*/
contract TestMultiCall {
    event Log(address caller, string func);

    uint public initValue;

    function func1(uint a) external returns (uint, uint) {
        // emit Log();
        initValue = a;
        return (a, block.timestamp);
    }

    function func2(uint b) external returns (uint, uint) {
        emit Log(msg.sender, "func2");
        return (b, block.timestamp);
    }

    function getData1() external pure returns (bytes memory) {
        return abi.encodeWithSignature("func1(uint256)", 1);
        // return abi.encodeWithSelector(this.func1.selector, 1);
    }

    function getData2() external pure returns (bytes memory) {
        return abi.encodeWithSignature("func2(uint256)", 2);
        // return abi.encodeWithSelector(this.func2.selector, 2);
    }
}

contract MultiCall {
    event Log(address caller, string func);
    /*
    targets:目标合约的地址
    datas: 调用目标合约的函数及参数信息

    multicall多重调用，是为了组合更复杂的合约函数
    */
    function multiCall(address[] calldata targets, bytes[] calldata datas)
        external 
        view 
        returns (bytes[] memory)
    {
        require(targets.length == datas.length, "target length != datas length");
        bytes[] memory results = new bytes[](targets.length);

        for (uint i; i < targets.length; i++) {
            //staticcall静态调用
            (bool success, bytes memory result) = targets[i].staticcall(datas[i]);
            require(success, "call failed");
            results[i] = result;
        }

        return results;
    }


    //普通的call调用，可以修改被调用合约的状态
    function commonCallFun(address target) external returns(bytes memory) {
        (bool success, bytes memory result) = target.call(abi.encodeWithSignature("func2(uint256)", 2));
        require(success);
        return result;
    }

    //staticcall调用，不能修改被调用合约的状态，否则会发生未知错误；同时，由于未修改状态所以在被调用的合约
    //中，不能使用emit方法
    function staticCallFun(address target) external view returns (bytes memory) {
        (bool success, bytes memory result) = target.staticcall(abi.encodeWithSignature("func1(uint256)", 1));
        require(success);
        return result;
    }
}