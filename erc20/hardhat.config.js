require("@nomicfoundation/hardhat-toolbox");
require('@nomicfoundation/hardhat-ethers');
require('@nomicfoundation/hardhat-ignition-ethers');

const myConfig = require("./config/my_config.js");


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  defaultNetwork: "base",
  networks: {
    base: {
      url: myConfig.url,
      chainId: myConfig.chainId,
      accounts: myConfig.accounts
    }
  }
};
