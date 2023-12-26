//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

interface IERC1155Errors {
    error ParamInvalid();

    error MissAuth();

    error AddressInvalid();

    error QuantityTooLarge();

    error ArithmeticOverflow();

    error CallFailed();
}