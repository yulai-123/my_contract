const {
    time,
    loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const {expect} = require("chai");

// 测试带时间锁的erc20
// 1. 两次transfer, 锁定时间100s, 200s
// 2. 未到时间尝试取回，余额不变
// 3. 时间过了100s取回，余额增加
// 4. 时间过了200s取回，余额增加
// 5. 时间过了一年取回，不再改变

describe("ERC20WithTimeLock", function() {
    async function deployERC20WithTimeLock() {
        const [owner, otherAccount] = await ethers.getSigners();
        const erc20WithTimeLockFactory = await ethers.getContractFactory("ERC20WithTimeLock");
        const erc20WithTimeLock = await erc20WithTimeLockFactory.deploy("tt", "tt", 18);

        await expect(erc20WithTimeLock.mint(owner, 10000)).not.to.be.reverted;
        expect(await erc20WithTimeLock.balanceOf(owner)).to.equal(10000);
        expect(await erc20WithTimeLock.balanceOf(otherAccount)).to.equal(0);


        await expect(erc20WithTimeLock.transferWithTimeLock(owner, otherAccount, 3000, Math.floor(Date.now() / 1000) + 100)).
            not.to.be.reverted;
        await expect(erc20WithTimeLock.transferWithTimeLock(owner, otherAccount, 7000, Math.floor(Date.now() / 1000) + 200)).
            not.to.be.reverted;

        expect(await erc20WithTimeLock.balanceOf(owner)).to.equal(0);
        expect(await erc20WithTimeLock.balanceOf(otherAccount)).to.equal(0);

        return {erc20WithTimeLock, owner, otherAccount};
    }

    it("mint&transfer", async function() {
        await loadFixture(deployERC20WithTimeLock);
    })

    it("retrieve", async function() {
        var {erc20WithTimeLock, owner, otherAccount} = await loadFixture(deployERC20WithTimeLock);
        
        expect(await erc20WithTimeLock.balanceOf(owner)).to.equal(0);
        expect(await erc20WithTimeLock.balanceOf(otherAccount)).to.equal(0);
        await time.increaseTo(Math.floor(Date.now() / 1000) + 110);


        await expect(erc20WithTimeLock.connect(otherAccount).retrieve()).not.to.be.reverted;
        expect(await erc20WithTimeLock.balanceOf(owner)).to.equal(0);
        expect(await erc20WithTimeLock.balanceOf(otherAccount)).to.equal(3000);

        await time.increaseTo(Math.floor(Date.now() / 1000) + 210);

        await expect(erc20WithTimeLock.connect(otherAccount).retrieve()).not.to.be.reverted;
        expect(await erc20WithTimeLock.balanceOf(owner)).to.equal(0);
        expect(await erc20WithTimeLock.balanceOf(otherAccount)).to.equal(10000);

        await time.increaseTo(Math.floor(Date.now() / 1000) + 310);

        await expect(erc20WithTimeLock.connect(otherAccount).retrieve()).not.to.be.reverted;
        expect(await erc20WithTimeLock.balanceOf(owner)).to.equal(0);
        expect(await erc20WithTimeLock.balanceOf(otherAccount)).to.equal(10000);
    })

})
