// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherWallet {
    address payable public owner;

    constructor () {
        owner = payable(msg.sender);
    }

    //在Remix界面填入value的值和单位，在Deployed Contracts->Low level interaction的Transact中可以直接转发
    //以太币给到EtherWallet钱包实例
    receive() external payable {}

    //从当前合约钱包中再取回金额
    function withdraw(uint amount) external {
        require(msg.sender == owner, "caller is not owner");
        payable(msg.sender).transfer(amount);
    }
}