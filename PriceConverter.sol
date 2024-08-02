// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
        

library PriceConverter {

    function showversion() public view  returns (uint256) {
       return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
    function getPrice()public view returns (uint256) {
        AggregatorV3Interface priceFeed= AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,)=priceFeed.latestRoundData();
        return  uint256(price*1e10);
    }
    function checkDecimals() public  view  returns (uint8) {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).decimals();
    }
    function convertToUsd(uint256 ethAmount) public view  returns (uint256) {
       uint256 ethPrice =getPrice();
       uint256 ethInUsdAmount =(ethPrice*ethAmount)/1e10;
       return ethInUsdAmount;
    }
}