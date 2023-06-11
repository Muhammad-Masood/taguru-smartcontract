import { ethers } from "hardhat";

async function main() {
  const TAGURU = await ethers.getContractFactory("TAGuru");
  const tag = await TAGURU.deploy();
  //await tag.deployed();
  console.log(`Deployed contract at address ${await tag.getAddress()}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
