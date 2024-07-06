// 1.  Import the `buildModule` function from the Hardhat Ignition module
const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

// 2. Export a module using `buildModule`
module.exports = buildModule("ERC20_Test", (m) => {

    // 3. Use the `getAccount` method to select the deployer account
    const deployer = m.getAccount(0);

    const name = "test-cat"
    const symbol = "test"
    const decimals = 9

    // 4. Deploy the `Box` contract
    const erc20Test = m.contract("ERC20", [name, symbol, decimals], {
        from: deployer,
    });
    // 5. Return an object from the module
    return { erc20Test };
});
