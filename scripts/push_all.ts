import { ethers } from "hardhat";

async function main() {
  console.log("Main")
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
