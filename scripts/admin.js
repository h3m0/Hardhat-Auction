const { deployments, ethers, getNamedAccounts } = require("hardhat");
const { getAccounts } = require("../hasbi");
let AUCTION, PROXY;

async function restartBidding() {		
	AUCTION = await ethers.getContract("Auction");
	const { deployer, tester, tester2, tester3 } = await getNamedAccounts();	
	const tx = await AUCTION.restartBidding({from: deployer});
	await tx.wait(1);
	console.log("Bidding Starto!!");
}

async function endBidding() {
	AUCTION = await ethers.getContract("Auction");
	const { deployer, tester, tester2, tester3 } = await getNamedAccounts();
	const tx = await AUCTION.endBidding({from: deployer});
	await tx.wait(1);
	console.log("Bidding Ended!");

}

async function awardHighestBidding() {
	BASIC = await ethers.getContract("BasicNFT");
	AUCTION = await ethers.getContract("Auction");
	const { deployer, tester, tester2, tester3 } = await getNamedAccounts();
	const tx = await AUCTION.awardHighestBidder(BASIC.address, {from: deployer});
	await tx.wait(1);
}

awardHighestBidding()
.then(() => process.exit(0))
.catch((error) => {
	console.error(error)
})