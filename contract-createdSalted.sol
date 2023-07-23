// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract D {
    uint public x;
    constructor(uint a) {
        x = a;
    }
}

contract C {

    event printAddress(address);
    
    function getBytes(uint arg) public pure returns (bytes32) {
        return bytes32(arg);
    }

    /*
    2种方式所创建的编译地址是相同的，但是跟在remix中部署后的地址是不同的，原因在于以下的方式指定了salt。
    Note：
    合约的编译地址 和 部署地址不是同一个概念！
    编译地址：是根据合约的源码生成的；它是合约源码的标识符，可以验证合约是否被篡改；但不能根据合约的编译地址直接得到合约的源代码；
    部署地址：是合约发布到区块链之后的地址。

    */
    function createDSalted(bytes32 salt, uint arg) public {
        // This complicated expression just tells you how the address
        // can be pre-computed. It is just there for illustration.
        // You actually only need ``new D{salt: salt}(arg)``.
        address predictedAddress = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            keccak256(abi.encodePacked(
                type(D).creationCode,
                abi.encode(arg)
            ))
        )))));

        emit printAddress(predictedAddress);

        D d = new D{salt: salt}(arg);
        require(address(d) == predictedAddress);
        emit printAddress(address(d));
    }
}