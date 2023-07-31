// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
1.  hash(message)：消息第一次的哈希值
2.  sign(hash(message), private key) | offchain -> signature
3.  ecrecover(hash(message), signature) == signer :根据消息及签名恢复出签名地址，跟入参的singer
对比是否一致

验证步骤：
1.找到metamask钱包的地址
2.将原消息进行hash计算，得到bytes32类型的数据
3.打开浏览器调试界面，执行如下命令
    ethereum.enable()
    account = "钱包地址"
    hash = "第2步的结果"
    ethereum.request({method:"personal_sig", params:[account,hash]})
    在弹出的metamask界面中允许签名
    在debug页面得到签名结果_sig
4.在Remix中调用verify函数，输入参数，看是否为true
*/

contract VerifySig {

    /*
    _signer:签名地址(metamask账户):0x0fDb1Aa640682e180e5F59D5990D2E7CDc7014dB   
    _message:消息体原文:syjnb666
    _sig消息体的签名:0x9d76927783219184a68cefd2a19e0c5036790c9f1f583511d9106aedac8866434a80325ba3fa36517b6a50a75333e986e628d65472f1e1f4098f8603dfd75d021c
    */
    function verify(address _signer, string memory _message, bytes memory _sig)
        external pure returns (bool) {
        bytes32 messageHash = getMessageHash(_message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recover(ethSignedMessageHash, _sig) == _signer;
    }

    function getMessageHash(string memory _message) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_message));
    }

    function getEthSignedMessageHash(bytes32 _messageHash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            _messageHash));
    }

    function recover(bytes32 _ethSignedMessageHash, bytes memory _sig) internal pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = _split(_sig);
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    /*
    疑问：既然_sig的长度为65字节，那么变量s、v的值已经超出内存大小了，怎么能正常取出数值呢？
    */
    function _split(bytes memory _sig) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(_sig.length == 65, "invalid signature length");

        assembly {
            r := mload(add(_sig, 32))
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        }
    }
}