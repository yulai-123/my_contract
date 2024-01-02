// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import "hardhat/console.sol";

contract HiddenPriceAuction {
    mapping (address => bytes32) firstPriceMap;
    uint256 _startBinddingTime;
    uint256 _secondStartTime;
    uint256 maxPrice;
    address winner;
    uint256 _endTime;

    constructor(uint256 startBinddingTime, uint256 secondStartTime, uint256 endTime) {
        _startBinddingTime = startBinddingTime;
        _secondStartTime = secondStartTime;
        _endTime = endTime;
    }

    // 第一轮叫价
    function firstRoundBindding(bytes32 signature) external payable {
        require(block.timestamp >= _startBinddingTime && 
            block.timestamp < _secondStartTime, "time invalid");
        firstPriceMap[msg.sender] = signature;
    }

    // 第二轮验证
    function secondRoundBindding(uint256 price, bytes memory salt) external payable {
        require(block.timestamp >= _secondStartTime &&
            block.timestamp < _endTime, "time invalid");
        bytes32 signature = keccak256(abi.encodePacked(msg.sender, price, salt));

        if (signature == firstPriceMap[msg.sender] && price > maxPrice) {
            maxPrice = price;
            winner = msg.sender;
        }
    }

    // 结束后手动取回
    function queryWinner() external view returns (address) {
        require(block.timestamp >= _endTime, "time invalid");

        return winner;
    }
}