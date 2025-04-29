// SPDX-License-Identifier: MIT

// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();
error FundMe__NotEnoughEth();
error FundMe__CallFailed();

contract FundMe {
    using PriceConverter for uint256;

    address[] private s_funders;
    mapping(address funder => uint256 amountFunded)
        private s_addressToAmountFunded;

    // immutable keyword saves gas b/c stored
    // directly in contract byte code
    address private immutable i_owner;

    // constant keyword saves gas b/c stored
    // directly in contract byte code
    uint256 public constant MINIMUM_USD = 5e18;

    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        if (msg.value.getConversionRate(s_priceFeed) < MINIMUM_USD) {
            revert FundMe__NotEnoughEth();
        }
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function withdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length;
        for (
            uint256 funderIndex = 0;
            funderIndex < fundersLength;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        if (!callSuccess) {
            revert FundMe__CallFailed();
        }
    }

    // Gas intensive withdraw function due to
    // repeated read of array length from storage
    // function withdraw() public onlyOwner {
    //     for (
    //         uint256 funderIndex = 0;
    //         funderIndex < s_funders.length;
    //         funderIndex++
    //     ) {
    //         address funder = s_funders[funderIndex];
    //         s_addressToAmountFunded[funder] = 0;
    //     }

    //     // reset funders array
    //     s_funders = new address[](0);

    //     // Sending ETH: https://solidity-by-example.org/sending-ether/
    //     // transfer
    //     //payable(msg.sender).transfer(address(this).balance);
    //     // send
    //     //bool sendSuccess = payable(msg.sender).send(address(this).balance);
    //     //require(sendSuccess, "Send failed");
    //     // call
    //     (bool callSuccess, ) = payable(msg.sender).call{
    //         value: address(this).balance
    //     }("");
    //     //require(callSuccess, "Call failed");
    //     if (!callSuccess) {
    //         revert FundMe__CallFailed();
    //     }
    // }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function getAddressToAmountFunded(
        address fundingAddress
    ) public view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Sender not contract owner!");
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    // In case user sends ETH without
    // calling fund() specifically
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
