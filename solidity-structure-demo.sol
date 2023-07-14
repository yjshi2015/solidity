// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

/*
合约的结构介绍
合约类似于面向对象的编程语言的类
*/
contract SimpleStorage {

    //1、State variable 状态变量，永久存在合约存储中
    uint storedData; 
    
    //2、Function，inside a contract
    function bid() public payable {
        //……
    }

    //3、Function modifiers,函数修改器（类似于切面）
    address public seller;
    //函数修改器
    modifier onlySeller() {
        require(
            msg.sender == seller,
            "only seller can call this."
        );
        _;
    }

    //函数修改器的应用
    function abort() public view onlySeller {
        //……
    }

    //4、事件event，能够方便的调用EVM的日志接口，向所有节点同步消息
    event highestBidIncreased(address bidder, uint amount);

    function bid1() public payable {
        // 向网络中所有节点散播消息
        emit highestBidIncreased(msg.sender, msg.value);
    }

    //5、错误
    error NotEnoughFunds(uint requested, uint available);
    mapping(address => uint) balances;
    function transfer(address to, uint amount) public {
        uint balance = balances[msg.sender];
        if (balance < amount) 
            revert NotEnoughFunds(amount, balance);
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    //6、struct types结构类型
    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    //7、枚举类型
    enum State {Created, Locked, Inactive}
}

// helper function defined outside of a contract
function helper(uint x) pure returns (uint) {
    return x * 2;
}