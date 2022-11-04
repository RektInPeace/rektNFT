import { ethers } from "hardhat";
// import { Rekt__factory } from '../frontend/src/typechain-types/factories/contracts/index';

async function main() {
  const Square = await ethers.getContractFactory("ImageTest");
  const square = await Square.deploy();

  await square.deployed();
  console.log(`TestImage Deployed to ${square.address}`);
  // await square.mintWithColor("red")
  // console.log(square.tokenURI(1))
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// ColorSquare: 0x2161D656dDEf1B6387Aee4679403997e17bE3e74
// REKT : 0xC2EBAf4366D23166AaaB1Bc9114eEDaaff74CcB1