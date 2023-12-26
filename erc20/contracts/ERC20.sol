// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import './IERC20.sol';
import './util/Strings.sol';

contract ERC20 is IERC20 {
    event Mint(address indexed _owner, uint256 _value);

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;


    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    function name() public view returns (string memory) {
        return (_name);
    }

    function symbol() public view returns (string memory) {
        return (_symbol);
    }

    function decimals() public view returns (uint8) {
        return (_decimals);
    }

    function totalSupply() public view returns (uint256) {
        return (_totalSupply);
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);

        return true;
    }

    function _transfer(address _from, address _to, uint256 _value) private {
        // 校验 _value 大于 0
        require(_value > 0, unicode"转账需要大于0");
        // 校验当前用户有这么多余额
        require(balances[_from] >= _value, unicode"当前用户余额不足");
        // 校验 _to 不是0
        require(_to != address(0), unicode"不能向0地址转账");
        // 校验是否溢出
        require(balances[_to] + _value >= 0, unicode"转账金额太大");

        // 当前用户余额减少
        balances[_from] -= _value;
        // 目标用户余额增加
        balances[_to] += _value;
        // 发送事件
        emit Transfer(_from, _to, _value);
    }


    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        // 是否有额度
        require(allowances[_from][_to] >= _value, unicode"额度不够");
        allowances[_from][_to] -= _value;
        _transfer(_from, _to, _value);

        return true;
    }


    function approve(address _spender, uint256 _value) public returns (bool) {
        // _spender 不为0
        require(_spender != address(0), unicode"目标用户不能为0");
        // 转账大于等于 0
        require(_value >= 0, unicode"额度需要大于等于0");
        // 设置转账额度
        allowances[msg.sender][_spender] = _value;
        // 释放转账事件
        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowances[_owner][_spender];
    }


    function mint(address _owner, uint256 _value) public returns (bool) {
        require(_owner != address(0), unicode"目标用户不能为0");
        require(_value > 0, unicode"生成需要大于0");
        require(_totalSupply + _value >= 0, unicode"生成溢出");

        _totalSupply += _value;

        balances[_owner] += _value;

        emit Mint(_owner, _value);

        return true;
    }
}