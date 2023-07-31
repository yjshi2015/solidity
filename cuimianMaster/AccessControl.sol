// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AccessControl {
    //如果状态变量发生了变更，一定要emit出event向以太坊网络上汇报
    //为了便于查看哪些角色和账户发生了变更，要加indexed修饰符，便于过滤查找
    event GrantRole(bytes32 indexed role, address indexed account);
    event RevokeRole(bytes32 indexed role, address indexed account);

    constructor() {
        _grantRole(ADMIN, msg.sender);
    }

    modifier OnlyRole(bytes32 _role) {
        require(roles[_role][msg.sender], "this account not permit");
        _;
    }
    //role -> account -> bool
    //key不建议使用string，动态数组，会消耗更多gas
    mapping(bytes32 => mapping(address => bool)) public roles;

    //0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42
    bytes32 private immutable ADMIN = keccak256(abi.encodePacked("ADMIN"));
    //0x2db9fd3d099848027c2383d0a083396f6c41510d7acfd92adc99b6cffcf31e96
    bytes32 private immutable USER = keccak256(abi.encodePacked("USER"));

    //内部函数的名称通常用下划线_开头
    function _grantRole(bytes32 _role, address _account) internal {
        roles[_role][_account] = true;
        emit GrantRole(_role, _account);
    }

    //封装了对应的外部函数，但并不希望所有人都可以调用，所以增加了modifier，
    //限制只有管理员可以修改
    function grant(bytes32 _role, address _account) external OnlyRole(ADMIN){
        _grantRole(_role, _account);
    }

    function revokeRole(bytes32 _role, address _account) external OnlyRole(ADMIN) {
        roles[_role][_account] = false;
        emit RevokeRole(_role, _account);
    }
}