import { ethers } from "hardhat";

async function main() {
  const Rekt = await ethers.getContractFactory("Rekt");
  const rekt = await Rekt.deploy("https://rektinpeace.herokuapp.com/goerli/token/");

  await rekt.deployed();
  console.log(`Rekt Deployed to ${rekt.address}`);
  // await square.mintWithColor("red")
  // console.log(square.tokenURI(1))
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
