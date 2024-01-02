// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./IERC20WithTimeLock.sol";
import "../ERC20.sol";
import "hardhat/console.sol";

contract ERC20WithTimeLock is ERC20, IERC20WithTimeLock {
    struct BalanceWithTimeLock {
        uint256 value;
        uint256 unlockTime;
    }

    mapping(address owner => BalanceWithTimeLock[]) balancesWithTimeLockMap;

    constructor(string memory name_, string memory symbol_, uint8 decimals_) 
        ERC20(name_, symbol_, decimals_) {}

    function transferWithTimeLock(
        address _from,
        address _to,
        uint256 _value,
        uint256 unlockTime
    ) external override payable {
        // 校验 _value 大于 0
        require(_value > 0, unicode"转账需要大于0");
        // 校验当前用户有这么多余额
        require(balances[_from] >= _value, unicode"当前用户余额不足");
        // 校验 _to 不是0
        require(_to != address(0), unicode"不能向0地址转账");
        // 校验是否溢出
        require(balances[_to] + _value >= 0, unicode"转账金额太大");
        require(unlockTime >= block.timestamp, unicode"解锁时间已经过去");

        balances[_from] -= _value;
        balancesWithTimeLockMap[_to].push(BalanceWithTimeLock({value: _value, unlockTime: unlockTime}));

        emit TransferWithTimeLock(_from, _to, _value, unlockTime);
    }

    function retrieve() external payable {
        // 遍历balancesWithTimeLockMap

        uint256 index = 0;
        uint256 value = 0;
        while (index < balancesWithTimeLockMap[msg.sender].length) {
            BalanceWithTimeLock storage balanceWithTimeLock = balancesWithTimeLockMap[msg.sender][index];
            if(block.timestamp >= balanceWithTimeLock.unlockTime) {
                console.log(block.timestamp, balanceWithTimeLock.unlockTime);
                value += balanceWithTimeLock.value;
                balancesWithTimeLockMap[msg.sender][index] = balancesWithTimeLockMap[msg.sender][balancesWithTimeLockMap[msg.sender].length - 1];
                balancesWithTimeLockMap[msg.sender].pop();
                continue;
            }
            index++;
        }

        require(balances[msg.sender] + value >= 0, unicode"金额太大");
        balances[msg.sender] += value;

        // 发布事件
        emit Retrieve(msg.sender, value);
    }
}