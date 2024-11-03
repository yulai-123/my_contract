const hre = require("hardhat");

const myConfig = require("../config/my_config.js");

async function main() {
    await addNumber(11)
    // await query()
}

function getWallet() {
    // 链接网络
    const baseURL = myConfig.url;
    const provider = new hre.ethers.JsonRpcProvider(baseURL);
    // 链接钱包 signer
    // const publicKey = myConfig.primaryAccount.publicKey;
    const privateKey = myConfig.primaryAccount.privateKey;
    const wallet = new hre.ethers.Wallet(privateKey, provider);
    return wallet;
}

function getTest0810Contract() {
    const wallet = getWallet()
    const test0810ABI = '[{"inputs":[{"internalType":"int256","name":"number","type":"int256"}],"name":"addNumber","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"int256","name":"number","type":"int256"}],"name":"minusNumber","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"sum","outputs":[{"internalType":"int256","name":"","type":"int256"}],"stateMutability":"view","type":"function"}]'
    const test0810Address = '0xd7c12FB2def3D7a18ffD70aFba4C5e96df283c4B'
    const test0810Contract = new hre.ethers.Contract(test0810Address, test0810ABI, wallet);
    return test0810Contract;
}

// 增加值
async function addNumber(count) {
    const test0810Contract = getTest0810Contract()
    console.log("增加number, 1")
    const tx = await test0810Contract.addNumber(count)
    console.log("交易详情：", tx);
}

// 查询值
async function query() {
    const test0810Contract = getTest0810Contract()
    const sum = await test0810Contract.sum()
    console.log("sum:", sum)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
