import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";
import "@nomicfoundation/hardhat-verify";

const config: HardhatUserConfig = {
  solidity: "0.8.18",
  networks: {
    // sepolia: {
    //   url:`https://eth-sepolia.g.alchemy.com/v2/${process.env.API_KEY}`,
    //   accounts: [process.env.PRIVATE_KEY as string],
    // },
    goerli:{
      url:`https://eth-goerli.g.alchemy.com/v2/${process.env.API_KEY}`,
      accounts:[process.env.PRIVATE_KEY as string],
    }
  },
  etherscan:{
    apiKey: process.env.ETHERSCAN_API,
  }
};

export default config;
