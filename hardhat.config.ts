import 'dotenv/config';
import '@typechain/hardhat'
import '@nomiclabs/hardhat-ethers'
import '@nomiclabs/hardhat-waffle'

import { HardhatUserConfig } from "hardhat/config";

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  paths: {
    sources: "./src",
  },
  solidity: {
    compilers: [
      {
        version: "0.8.10",
        settings: {
          optimizer: {
            enabled: false,
            runs: 7500,
          },
        },
      },
    ]
  },
/*  networks: {
    eth_mainnet: {
      url: "https://rpc.ankr.com/eth",
      accounts: [process.env.PRIVATE_KEY],
    },
    goerli: {
      url: "https://rpc.ankr.com/eth_goerli",
      accounts: [process.env.PRIVATE_KEY],
    },
    polygon_mainnet: {
      url: "https://rpc.ankr.com/polygon",
      accounts: [process.env.PRIVATE_KEY],
    },
    mumbai: {
      url: "https://rpc.ankr.com/polygon_mumbai",
      accounts: [process.env.PRIVATE_KEY],
    },
    optimism: {
      url: "https://rpc.ankr.com/optimism",
      accounts: [process.env.PRIVATE_KEY],
    },
    optimism_kovan: {
      url: "https://kovan.optimism.io/",
      accounts: [process.env.PRIVATE_KEY],
    },
    ropsten: {
      url: process.env.ROPSTEN_URL || "",
      accounts: [process.env.PRIVATE_KEY],
    },
  }, */
  mocha: { timeout: 0 }
};

export default config;
