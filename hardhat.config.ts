import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import '@typechain/hardhat'

const GOERLI_PRIVATE_KEY = "a8d4a11d32b39d1a6b8744542d37d533b565747c5ebff135f7fb0562d58a918e"; // Dev Wallet
const ALCHEMY_API_KEY = "oeNqFFRiojay_sJv6VMdBeH5A9kpEn7k";

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY]
    }
  },
  typechain: {
    outDir: 'typechain-types',
    target: 'ethers-v5',
    alwaysGenerateOverloads: false, // should overloads with full signatures like deposit(uint256) be generated always, even if there are no overloads?
    externalArtifacts: ['externalArtifacts/*.json'], // optional array of glob patterns with external artifacts to process (for example external libs from node_modules)
    dontOverrideCompile: false // defaults to false
  },
  paths: {
    tests:"./scripts/test"
  }
};

export default config;
