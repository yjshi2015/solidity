// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
hash算法的两个特性：
1、不可以逆向，即根据哈希值无法推算出原来的值
2、输入值即使有很小的改变，输出值也会大不相同

针对encodePacked紧密型打包会造成哈希碰撞的情况，可采用encode打包的方式，或者在2个同类型的参数中间，增加一个
不同类型的参数，如函数dealCollision
*/
contract TestHash {
    function hash(string memory text, uint num, address addr) external pure returns (bytes32) {
        //紧密型打包，会省略掉为0的高位，会导致哈希碰撞
        return keccak256(abi.encodePacked(text, num, addr));
    }

    function encode(string memory text1, string memory text2) external pure returns (bytes memory) {
        return abi.encode(text1, text2);
    }

    /*
    紧密型打包会造成哈希碰撞，比如
    "AAA", "BBB"的哈希值 == "AA", "ABBB"的哈希值(0x414141424242)
    */
    function encodePack(string memory text1, string memory text2) external pure returns (bytes memory) {
        return abi.encodePacked(text1, text2);
    }

    //连续相同类型的输入之间，加入其它类型的值，能避免哈希碰撞
    function dealCollision(string memory text1, uint x, string memory text2) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(text1, x, text2));
    }
}