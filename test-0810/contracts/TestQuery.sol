// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract TestQuery {
    int public sum;
    // addNumber 加数
    function addNumber(int number) public {
        sum += number;
    }

    // minusNumber 减数
    function minusNumber(int number) public {
        sum -= number;
    }
}
