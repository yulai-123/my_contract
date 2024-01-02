// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../IERC20.sol";

interface IERC20WithTimeLock is IERC20 {
    event TransferWithTimeLock(address indexed _from, address indexed _to, uint256 _value, uint256 unlockTime);
    event Retrieve(address indexed owner, uint256 _value);

    function transferWithTimeLock(address _from, address _to, uint256 _value, uint256 unlockTime) external payable;
    function retrieve() external payable;
}