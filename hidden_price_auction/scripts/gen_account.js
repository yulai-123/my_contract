const hre = require("hardhat");

// 创建一个随机的钱包
const wallet = hre.ethers.Wallet.createRandom();

// 获取私钥
const privateKey = wallet.privateKey;

// 输出私钥
console.log("私钥:", privateKey);

// 获取钱包地址
const address = wallet.address;

// 输出钱包地址
console.log("钱包地址:", address);