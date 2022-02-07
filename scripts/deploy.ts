import { ethers } from "hardhat";

async function main() {
  const ERC721Collection = await ethers.getContractFactory("ERC721Collection");
  const erc721collection = await ERC721Collection.deploy();

  await erc721collection.deployed();

  console.log("ERC721Collection deployed to:", erc721collection.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
