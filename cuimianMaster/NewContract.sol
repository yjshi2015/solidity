// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Account {
    address public bank;
    address public owner;

    constructor(address _owner) payable {
        bank = msg.sender;
        owner = _owner;
    }
}

contract AccountFactory {
    Account[] public accounts;

    //通过new的方式部署Account合约，不用通过Remix来部署Account合约
    function createAccount(address owner) payable external {
        //account是部署的Account合约的address地址
        Account account = new Account{value : msg.value}(owner);
        accounts.push(account);
    }
}