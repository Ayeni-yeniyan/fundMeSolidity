// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMEME {
// 1e10 is one ethereum???
    uint256 public minumumUsd=5e18;
    // Using libraries like extensions in dart
    using PriceConverter for uint256;
    // store the address that sent us eth
    address[] funders;
    mapping (address funder=> uint256 amountFunded) public  addressToAmountFunded;
    function fund() public payable  {
        require (msg.value.convertToUsd()>=minumumUsd,"Eth sent is not enough");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender]=msg.value+addressToAmountFunded[msg.sender];

    }
    function withdraw() public  {
       for (uint256 funderIndex=0; funderIndex<funders.length; funderIndex++) 
       {
       address funder= funders[funderIndex];
        addressToAmountFunded[funder]=0;
       }
        funders=new address[](0);

        // Three ways to transfer to a wallet
        // you have to make the address payable
        // Transfer will send and automatically check/ revert if the transaction fails
        payable (msg.sender).transfer(address(this).balance);
        // Send will return a bool without reverting. You should revert yourself based on the bool with a required check
       bool transactionSuccessful= payable (msg.sender).send(address(this).balance);
        require(transactionSuccessful,"You can't withdraw at this moment");
        (bool tSuccess,/* bytes dataReturned*/) =payable (msg.sender).call{value: address(this).balance}("");
                require(tSuccess,"You can't withdraw at this moment");
    }
}