// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

contract FallbackExample {
    uint256 public result = 0;

    // Special function, triggered every time ETH is sent/transaction made to the contract, without any calldata
    // Without function keyword
    // always "external payable"
    receive() external payable {
        result = 1;
    }

    // Another special function, triggered when calldata isn't matched with any function
    // Without function keyword
    // always "external payable"
    fallback () external payable {
        result = 2;
    }
}