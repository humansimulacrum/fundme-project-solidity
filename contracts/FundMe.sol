// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    // It's like to add something to Number prototype
    using PriceConverter for uint256;

    // constant keyword saves gas, works like in JS
    uint256 public constant MINIMUM_USD = 50 * 1e18;

    // immutable saves gas as well, works if we are only setting the variable once
    address public immutable i_owner;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    constructor() {
        // msg.sender of the constructor is the address, who deployed the smart contract
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= MINIMUM_USD,
            "Didn't send enough"
        ); // 1e18 = 10 * 18 Wei = 1 ETH
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner{
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        // resetting the array
        funders = new address[](0);

        // msg.sender = address
        // payable(msg.sender) = payable

        // "this" keyword points to the context of the contract

        // transfer the funds (2300 gas, returns error if something is wrong)

        // payable(msg.sender).transfer(address(this).balance);

        // send the funds (2300 gas, returns bool)

        // bool isSendSuccess = payable(msg.sender).send(address(this).balance);
        // require(isSendSuccess, "Send failed");

        // call (forward all gas, returns bool)
        // It's the recommended way to send/receive ETH

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");

        require(callSuccess, "Call failed");
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    // like middleware in the express
    modifier onlyOwner() {
        // require(msg.sender == i_owner, "You are not authorized");
        // _ means "do the rest of the code"
        // _;

        // Custom error is more gas-efficient way, than require

        // Revert is basically the failed require
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }
}