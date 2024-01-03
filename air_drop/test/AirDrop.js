const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("AirDrop", function() {
    async function initContract() {
        const [owner, secondAccount] = await ethers.getSigners();
        const factory = await ethers.getContractFactory("AirDrop");
        const contract = await factory.deploy();

        expect(await contract.balanceOf(owner.address)).to.equal(100000000);

        return {contract, owner, secondAccount};
    } 

    it("airdrop", async function() {
        const {contract, owner, secondAccount} = await loadFixture(initContract);
        
        await expect(contract.connect(secondAccount).airDrop()).not.to.be.reverted;

        expect(await contract.balanceOf(secondAccount.address)).to.equal(1000);
        await expect(contract.connect(secondAccount).airDrop()).to.be.reverted;
        expect(await contract.connect(secondAccount).balanceOf(secondAccount.address)).to.equal(1000);
    })
})
