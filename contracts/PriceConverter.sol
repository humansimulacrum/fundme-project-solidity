// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

// Library can't:
// - Have any state variables
// - Send ether
// All functions in libraries are internal
// It can send calls to other contracts

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        (, int256 price, , , ) = priceFeed.latestRoundData();

        // to cast type we can just wrap in the constructor
        return uint256(price * 1e10);
    }

    // If we are "linking this method to the uint256 prototype", uint256 is passed as the first arg to the function
    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
