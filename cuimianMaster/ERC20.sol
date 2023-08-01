// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
ERC20标准为以太坊网络中的代币标准
*/
interface IERC20 {
    
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    //owner给spender批准的额度
    function allowance(address owner, address spender) external view returns (uint);

    //当前用户批准给spender的转账额度
    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);
}

/*
新发现：对于public类型的state variable（address/uint/mapping），会自动生成get方法
*/
contract ERC20 is IERC20 {
    address immutable owner;
    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "Test";
    string public symbol = "TEST";
    uint8 public decimals = 18;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner(address account) {
        require(account == owner, "not owner");
        _;
    }

    function transfer(address recipient, uint amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    //当前用户批准给spender的转账额度
    function approve(address spender, uint amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint amount) external returns (bool) {
        allowance[sender][recipient] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    //铸币
    function mint(uint amount) external onlyOwner(msg.sender){
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    //销毁
    function burn(uint amount) external onlyOwner(msg.sender){
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}