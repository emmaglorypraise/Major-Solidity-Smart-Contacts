// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

  /// @title Auction contract 
  /// @author Glory Praise Emmanuel
  /// @dev A contract that accepts bids for an item then sells it to the highest bidder

  /// set auction function and set auction price as current bid, set require to be higher than current bid,  after bidding, the current bid should increase
 
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract AuctionNFT  is ERC721, Ownable {

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
    }

    ///  @dev mint to a random address with the safeMint function
    /// then deploy Auction contract while setting address minted to as seller
    function safeMint(address to) public {
        uint256 tokenId = 20;
        _safeMint(to, tokenId);
    }

}

contract Auction {
  
  uint public startingPrice;

  uint public highestBid;

  address public seller;

  address public highestBidder;

  IERC721 public nft;
  
  uint public nftId;

  bool public AuctionTimeOn;

  uint auctionTime;

  struct Bidder{
    bool bidded;
    uint amount;
  }

  mapping (address => Bidder) public returnOutBids;

  /// @dev check aution time
  modifier checkAuctionTime {
    require(auctionTime < block.timestamp, "Not Auction time yet");
    _;
  }
  /// @dev check if auction has started
  modifier checkAuctionStatus {
    require(AuctionTimeOn == true, "Auction not started");
    _;
  }

  /// @dev checks if bidder is seller of NFT
  modifier checkBidderStatus {
    require(msg.sender != seller, "You can't participate in this auction");
    _;
  }

  /// @dev calculate to know highest bid
  modifier checkHighestBidder {
    require(msg.value > 0, "You need money to bid");
    require(msg.value >= startingPrice, "You need current bid ammount or more money to bid");
    if (highestBid == 0) {
      highestBid +=  msg.value;
      highestBidder = msg.sender;
      returnOutBids[highestBidder].amount = highestBid;
      startingPrice = highestBid;
    } 

    if (msg.value > highestBid) {
      returnOutBids[highestBidder].amount = highestBid;
      highestBid =  msg.value;
      highestBidder = msg.sender;
      startingPrice = highestBid;
    }

    if (msg.value < highestBid) {
      returnOutBids[msg.sender].amount = msg.value;
      startingPrice = highestBid;
    }
    _;
  }


  /// @dev checks if auction has ended
  modifier endAuctionCheck {
    require(AuctionTimeOn == false, "Wait for auction to end");
    _;
  }

  constructor(address _nft, uint _nftId, uint _startingPrice, uint _biddingTime, address _seller){
    nft = IERC721(_nft);
    nftId = _nftId;
    seller = _seller;
    startingPrice = _startingPrice;
    auctionTime = block.timestamp + _biddingTime; // e.g. 4 or 5 to avoid waiting for a long time while testing
  }

  /// @dev start auction function
  function startAuction() public {
    AuctionTimeOn =  true;

    /// this is optional if you dont want to use the ERC721 safeMint function in the first contract
    nft.transferFrom(msg.sender, address(this), nftId);
  }

  /// @dev bid function
  function bid() public payable checkAuctionTime checkAuctionStatus checkBidderStatus checkHighestBidder  {
    Bidder storage checkBidder =  returnOutBids[msg.sender];
    require(checkBidder.bidded == false, "You have already bidded, wait for the result!");
    
    checkBidder.bidded = true;
  }
   
  /// @dev end auction function
  function endAuction() public payable {
    AuctionTimeOn = false;
    if (highestBidder != address(0)) {
            nft.safeTransferFrom(address(this), highestBidder, nftId);
          payable(seller).transfer(highestBid);
    } else {
        nft.safeTransferFrom(address(this), seller, nftId);
    }
  }

  /// @dev withdraw function for outbidders
  function withdrawOutBids() public payable endAuctionCheck returns (bool success) {

    uint amount = returnOutBids[msg.sender].amount;

    require (amount > 0, "You dont have any money to withdraw");

    returnOutBids[msg.sender].amount = 0;

    require(msg.sender != address(0), "Invalid address");
    
    payable(msg.sender).transfer(amount);

    return success;
  }

}