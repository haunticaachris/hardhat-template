require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
require("hardhat-gas-reporter");
require("solidity-coverage");

/*
Example .env

NODE_URL="http://127.0.0.1:8545"
PRIVATE_KEYS="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
*/
const nodeURL = process.env.NODE_URL;
const privateKeys = process.env.PRIVATE_KEYS.split(",");

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  console.log("Accounts");
  for (const account of accounts) {
    console.log(account.address);
  }
});

task("network", "Prints the network configuration", async (taskArgs, hre) => {
  console.log("Node URL: " + nodeURL);

  console.log("Private keys");
  for (const key of privateKeys) {
    console.log(key);
  }
});

module.exports = {
  defaultNetwork: "hardhat",
  gasReporter: {
    currency: "USD",
  },
  networks: {
    hardhat: {
      chainId: 1337,
    },
    localhost: {
      url: "http://127.0.0.1:8545",
      chainId: 1337,
    },
    main: {
      url: nodeURL,
      accounts: privateKeys,
    },
  },
  paths: { artifacts: "./artifacts" },
  solidity: {
    version: "0.8.14",
    settings: {
      optimizer: {
        enabled: true,
        runs: 100000000,
      },
    },
  },
};
