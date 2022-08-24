// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

  /// @title Auction contract 
  /// @author Glory Praise Emmanuel
  /// @dev A contract that accepts bids for an item then sells it to the highest bidder

  // auction - use custom errors

  // set auction function and set auction price as current bid, set require to be higher than current bid
  // after bidding, the current bid should increase
  // when deadline has reached, and auction ends 
  // bid function -  minimum bid is 2eth, bidder should be 
  // end auction - swaps nft for money between owner and buyer
  // if aution ends and nobody bids, transfer back to owner, at start auction, transfer nft to contract
  // when bid time is up, collect money to seller then transfer nft to buyer 
  // transfer bid
  // mapping to track bidders

contract Auction {
  
  uint public startingPrice;

  uint public highestBid;

  address public seller;

  address public highestBidder;

  bool public AuctionTimeOn;

  uint auctionTime = block.timestamp + 30 minutes;

  struct Bidder{
    bool bidded;
  }

  mapping (address => uint) public returnOutBids;

  mapping (address => Bidder) public checkBidders;

  modifier checkAuctionTime {
    require(auctionTime > block.timestamp, "Not Auction time yet");
    _;
  }

  modifier checkAuctionStatus {
    require(AuctionTimeOn == true, "Auction not started");
    _;
  }

  modifier checkBidderStatus {
    require(msg.sender != seller, "You can't participate in this auction");
    _;
  }

  modifier checkHighestBidder {
    require(msg.value > 0, "You need money to bid");
    require(msg.value >= startingPrice, "You need current bid ammount or more money to bid");
    if (highestBid == 0) {
      highestBid +=  msg.value;
      highestBidder = msg.sender;
      startingPrice = startingPrice + 1000000000000000000;
    } 
    _;
  }

  constructor(){
    seller = msg.sender;
    startingPrice = 3000000000000000000;
  }

  function startAuction() public {
    AuctionTimeOn =  true;
    // transfer nft to contract
  }

  function bid() public payable checkAuctionTime checkAuctionStatus checkBidderStatus checkHighestBidder  {
    Bidder storage checkBidder =  checkBidders[msg.sender];
    require(checkBidder.bidded == false, "You have already bidded, wait for the result!");
    checkBidder.bidded = true;
  }

  function endAuction() public payable {
    AuctionTimeOn = false;
    // highestBid = currentBid;
    // checkHighesBidder != zero address
    payable(highestBidder).transfer(1000);
    payable(seller).transfer(msg.value);
  }

  function withdrawOutBids() public payable  returns (bool result) {
    require(AuctionTimeOn = false, "Wait for auction to end");

    uint amount = returnOutBids[msg.sender];

    require (amount > 0, "You dont have any money to withdraw");

    returnOutBids[msg.sender] = 0;

    // require(msg.sender != 0000, "Invalid address");
    
    payable(msg.sender).transfer(10000);

    return result;
  }

}