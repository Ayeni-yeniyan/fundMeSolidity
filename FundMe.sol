// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

// Custom errors? read up on it  
error UnAuthorised();


contract FundMEME {
    // Constants and immutables reduce gas cost when you are only setting the variables once.
    // constants are use when you create the variable similar to const in flutter
    // immutable is similar to final where you can only assign the value of the variable once.
// 1e10 is one ethereum???
    uint256 public constant MINIMUN_USD=5e18;
    // Using libraries like extensions in dart
    using PriceConverter for uint256;
    address public immutable i_owner;
    constructor() {
        i_owner=msg.sender;
    }
    // This receive is a special function triggered when you send eth with interacting with the fund function itself
    // calling [fund()] to ensure we store the customer details
    receive() external payable {fund(); }
    // This is a special functions triggered when a data is sent with the transaction.
    // This is fall back since receive can't handle data inputs, only empty transactions. 
    fallback()  external payable {fund(); }
    // store the address that sent us eth
    address[] funders;
    mapping (address funder=> uint256 amountFunded) public  addressToAmountFunded;
    function fund() public payable  {
        require (msg.value.convertToUsd()>=MINIMUN_USD,"Eth sent is not enough");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender]=msg.value+addressToAmountFunded[msg.sender];

    }
    function withdraw() public ownerOnly {
        // must be the owner to withdraw from contract balance
        for (uint256 funderIndex=0; funderIndex<funders.length; funderIndex++) 
       {
       address funder= funders[funderIndex];
        addressToAmountFunded[funder]=0;
       }
        funders=new address[](0);

        // Three ways to transfer to a wallet
        // you have to make the address payable
        // Transfer will send and automatically check/ revert if the transaction fails
        // payable (msg.sender).transfer(address(this).balance);
        // Send will return a bool without reverting. You should revert yourself based on the bool with a required check
    //    bool transactionSuccessful= payable (msg.sender).send(address(this).balance);
    //     require(transactionSuccessful,"You can't withdraw at this moment");
        // call is a powerful low level function. Prefer to use it.
        (bool tSuccess,/* bytes dataReturned*/) =payable (msg.sender).call{value: address(this).balance}("");
                require(tSuccess,"You can't withdraw at this moment");
    }

    // Modifiers are essentiall functions that can be prefixed to a fuction. the _ refers to the other functions functionality
    modifier ownerOnly(){
        require(msg.sender==i_owner,"You must be the owner of the contract to perform this action!!!");
        _;/*This means the function actions that you have attached this contract to.*/
    }
}