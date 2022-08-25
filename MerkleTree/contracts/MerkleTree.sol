// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


  /// @title  Merkle Tree contract 
  /// @author Glory Praise Emmanuel
  /// @dev A contract that creates, updates, views, completes and deletes tasks

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleTreeNFT  is ERC721, Ownable {
    using Counters for Counters.Counter;
    bytes32 public merkleRoot;

    Counters.Counter private _tokenIdCounter;

    constructor(bytes32 _merkleRoot) ERC721("MerkleTreeNFT", "MTN") {
        merkleRoot = _merkleRoot;
    }

    function safeMint(address to, bytes32[] memory proof) public {
        require(isValid(proof, keccak256(abi.encodePacked(msg.sender))), "Not Whitelisted");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
        return MerkleProof.verify(proof, merkleRoot, leaf);
    }
}
