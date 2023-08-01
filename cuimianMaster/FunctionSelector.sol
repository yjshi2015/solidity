// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FunctionSelector {
    //获取函数的selector选择器，长度为8的十六进制数据（4字节）
    //_func : transfer(address,uint256)
    function getSelectorByHash(string calldata _func) external pure returns (bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }
}


contract Receiver {
    event Log(bytes data);

    /*
    _to:0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    amount:11
    data:0xa9059cbb000000000000000000000000ab8483f64d9c6d1ecf9b849ae677dd3315835cb2000000000000000000000000000000000000000000000000000000000000000b
    data解析后（共136个十六进制字符 = 8 + 64 + 64）
    函数选择器selector：8个十六进制字符，即4字节     (a9059cbb)
    第一个参数_to :     64个十六进制字符，即32字节   (000000000000000000000000ab8483f64d9c6d1ecf9b849ae677dd3315835cb2)
    第二个参数amount:   64个十六进制字符，即32字节   (000000000000000000000000000000000000000000000000000000000000000b)

    可通过上个合约单独生成selector，进行对比

    我们在通过call调用函数时，传入的参数data，即包含了函数selector，又包含了参数
    */
    function transfer(address _to, uint amount) external {
        emit Log(msg.data);
    }
}