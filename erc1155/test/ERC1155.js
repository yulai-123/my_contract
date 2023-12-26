const {
    loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const {expect} = require("chai");

describe("ERC1155", function() {
    async function deployERC1155() {
        const [owner, otherAccount] = await ethers.getSigners();
        const ERC1155Factory = await ethers.getContractFactory("ERC1155");
        const erc1155 = await ERC1155Factory.deploy();
        return {erc1155, owner, otherAccount};
    }

    it("Deployment", async function() {
        await loadFixture(deployERC1155);
    })

    it("Mint", async function() {
        const {erc1155, owner} = await loadFixture(deployERC1155);

        await expect(erc1155.mint(owner, 1, 1000, ethers.toUtf8Bytes("123"))).not.to.be.reverted;

        expect(await erc1155.balanceOf(owner, 1)).to.equal(1000);
    })

    it("Operation", async function() {
        const {erc1155, owner, otherAccount} = await loadFixture(deployERC1155);

        await expect(erc1155.mint(owner, 1, 1000, ethers.toUtf8Bytes("123"))).not.to.be.reverted;
        expect(await erc1155.balanceOf(owner, 1)).to.equal(1000);
        await expect(erc1155.setApprovalForAll(otherAccount, true)).not.to.be.reverted;
        expect(await erc1155.isApprovedForAll(owner, otherAccount)).to.equal(true);
        expect(await erc1155.balanceOf(otherAccount, 1)).to.equal(0);
        
        await expect(erc1155.connect(otherAccount).
            safeTransferFrom(owner, otherAccount, 1, 500, ethers.toUtf8Bytes(""))).not.to.be.reverted;
        expect(await erc1155.balanceOf(otherAccount, 1)).to.equal(500);
        expect(await erc1155.balanceOf(owner, 1)).to.equal(500);
    })
})
