// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
期望以下2个函数的调用发生在1个区块上，但实际中可能不会如此
*/
contract TestMultiCall {
    function func1(uint a) external view returns (uint, uint) {
        return (a, block.timestamp);
    }

    function func2(uint b) external view returns (uint, uint) {
        return (b, block.timestamp);
    }

    function getData1() external pure returns (bytes memory) {
        return abi.encodeWithSignature("func1(uint256)", 1);
        // return abi.encodeWithSelector(this.func1.selector, 1);
    }

    function getData2() external pure returns (bytes memory) {
        return abi.encodeWithSignature("func1(uint256)", 2);
        // return abi.encodeWithSelector(this.func2.selector, 2);
    }
}

contract MultiCall {
    /*
    targets:目标合约的地址
    datas: 调用目标合约的函数及参数信息

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
}