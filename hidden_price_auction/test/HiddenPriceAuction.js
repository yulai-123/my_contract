const {
    time,
    loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const {expect} = require("chai");

describe("HiddenPriceAuction", function() {
    async function initHiddenPriceAuction() {
        const [owner, secondAccount, thirdAccount] = await ethers.getSigners();
        const factory = await ethers.getContractFactory("HiddenPriceAuction");
        const contract = await factory.deploy(Math.floor(Date.now() / 1000), 
            Math.floor(Date.now() / 1000) + 100, Math.floor(Date.now() / 1000) + 200);

            return {contract, owner, secondAccount, thirdAccount};
    }

    it("bidding", async function() {
        const {contract, owner, secondAccount, thirdAccount} = await loadFixture(initHiddenPriceAuction);

        var hash = ethers.solidityPackedKeccak256(["address", "uint256", "bytes"],
            [owner.address, 100, ethers.toUtf8Bytes("11")]);
        await expect(contract.firstRoundBindding(hash)).not.to.be.reverted;

        var hash = ethers.solidityPackedKeccak256(["address", "uint256", "bytes"],
            [secondAccount.address, 200, ethers.toUtf8Bytes("11")]);
        await expect(contract.connect(secondAccount).firstRoundBindding(hash)).not.to.be.reverted;

        var hash = ethers.solidityPackedKeccak256(["address", "uint256", "bytes"],
            [thirdAccount.address, 300, ethers.toUtf8Bytes("11")]);
        await expect(contract.connect(thirdAccount).firstRoundBindding(hash)).not.to.be.reverted;

        await time.increaseTo(Math.floor(Date.now() / 1000) + 100);
        // owner 出价100，secondAccount 出价错误，thirdAccount 出价300
        await expect(contract.secondRoundBindding(100, ethers.toUtf8Bytes("11"))).not.to.be.reverted;
        await expect(contract.connect(secondAccount).secondRoundBindding(200, ethers.toUtf8Bytes("1"))).not.to.be.reverted;
        await expect(contract.connect(thirdAccount).secondRoundBindding(300, ethers.toUtf8Bytes("11"))).not.to.be.reverted;

        
        await time.increaseTo(Math.floor(Date.now() / 1000) + 200);
        // thirdAccount 为winner
        expect(await contract.queryWinner()).to.equal(thirdAccount.address);
    })
})
