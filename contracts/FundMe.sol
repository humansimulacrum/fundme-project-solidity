// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./PriceConverter.sol";

contract FundMe {
    // It's like to add something to Number prototype
    using PriceConverter for uint256;

    uint256 public mininumUsd = 50 * 1e18;

    address public owner;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    constructor() {
        // msg.sender of the constructor is the address, who deployed the smart contract
        owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= mininumUsd,
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

    // like middleware in the express
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not authorized");
        // _ means "do the rest of the code"
        _;
    }
}
