const hre = require("hardhat");

async function main() {
    const url = "http://127.0.0.1:8545";
    const provider = new hre.ethers.JsonRpcProvider(url);
    const publicKey = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
    const privateKey = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";
    const wallet = new hre.ethers.Wallet(privateKey, provider);
    const erc20ABI = '[{"inputs":[{"internalType":"string","name":"name_","type":"string"},{"internalType":"string","name":"symbol_","type":"string"},{"internalType":"uint8","name":"decimals_","type":"uint8"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"_owner","type":"address"},{"indexed":true,"internalType":"address","name":"_spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"_value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"_owner","type":"address"},{"indexed":false,"internalType":"uint256","name":"_value","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"_from","type":"address"},{"indexed":true,"internalType":"address","name":"_to","type":"address"},{"indexed":false,"internalType":"uint256","name":"_value","type":"uint256"}],"name":"Transfer","type":"event"},{"inputs":[{"internalType":"address","name":"_owner","type":"address"},{"internalType":"address","name":"_spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"remaining","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"address","name":"","type":"address"}],"name":"allowances","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_spender","type":"address"},{"internalType":"uint256","name":"_value","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"balance","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"balances","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_owner","type":"address"},{"internalType":"uint256","name":"_value","type":"uint256"}],"name":"mint","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_to","type":"address"},{"internalType":"uint256","name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"success","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_from","type":"address"},{"internalType":"address","name":"_to","type":"address"},{"internalType":"uint256","name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"success","type":"bool"}],"stateMutability":"nonpayable","type":"function"}]';
    const erc20Address = '0x9fe46736679d2d9a65f0992f2272de9f3c7fa6e0';
    const erc20Contract = new hre.ethers.Contract(erc20Address, erc20ABI, wallet);

    const publicKeyOfB = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8";
    let balanceOfA = await erc20Contract.balanceOf(publicKey);
    let balanceOfB = await erc20Contract.balanceOf(publicKeyOfB);
    console.log("A用户余额: ", balanceOfA, "B用户余额: ", balanceOfB);

    console.log("为A增加1000余额，为B增加2000余额");
    let tx = await erc20Contract.mint(publicKey, 1000);
    await tx.wait();
    tx = await erc20Contract.mint(publicKeyOfB, 2000);
    await tx.wait();

    balanceOfA = await erc20Contract.balanceOf(publicKey);
    balanceOfB = await erc20Contract.balanceOf(publicKeyOfB);
    console.log("A用户余额: ", balanceOfA, "B用户余额: ", balanceOfB);
    
    console.log("A给B转账500");
    tx = await erc20Contract.transfer(publicKeyOfB, 500);
    await tx.wait();
    balanceOfA = await erc20Contract.balanceOf(publicKey);
    balanceOfB = await erc20Contract.balanceOf(publicKeyOfB);
    console.log("A用户余额: ", balanceOfA, "B用户余额: ", balanceOfB);

    console.log("A给B授权1000");
    tx = await erc20Contract.approve(publicKeyOfB, 1000);
    await tx.wait();
    let allowance = await erc20Contract.allowance(publicKey, publicKeyOfB);
    console.log("授权剩余: ", allowance);

    console.log("B使用授权转账100");
    tx = await erc20Contract.transferFrom(publicKey, publicKeyOfB, 100);
    await tx.wait();
    allowance = await erc20Contract.allowance(publicKey, publicKeyOfB);
    console.log("授权剩余: ", allowance);
    balanceOfA = await erc20Contract.balanceOf(publicKey);
    balanceOfB = await erc20Contract.balanceOf(publicKeyOfB);
    console.log("A用户余额: ", balanceOfA, "B用户余额: ", balanceOfB);

    console.log("B使用授权转账100000");
    let withError = false;
    tx = await erc20Contract.transferFrom(publicKey, publicKeyOfB, 100000).catch((error) => {
        console.log("发现错误", error);
        withError = true;
    });
    if (!withError) {
        await tx.wait();
    }
    allowance = await erc20Contract.allowance(publicKey, publicKeyOfB);
    console.log("授权剩余: ", allowance);
    balanceOfA = await erc20Contract.balanceOf(publicKey);
    balanceOfB = await erc20Contract.balanceOf(publicKeyOfB);
    console.log("A用户余额: ", balanceOfA, "B用户余额: ", balanceOfB);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});