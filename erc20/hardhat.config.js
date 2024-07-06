require("@nomicfoundation/hardhat-toolbox");
require("../my_config.js");

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
