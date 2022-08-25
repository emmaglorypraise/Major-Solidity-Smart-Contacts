import { ethers } from "hardhat";

async function main() {

  const MerkleTreeNFT = await ethers.getContractFactory("MerkleTreeNFT");
  const merkleTreeNFT = await MerkleTreeNFT.deploy("input merkleroot");

  await merkleTreeNFT.deployed();

  console.log("MerkleTreeNFT deployed to:", merkleTreeNFT.address);

// merkleTreeNFT.methods.safeMint(address, proof).send({ from: address })

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
