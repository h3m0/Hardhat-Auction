const { deployments, ethers } = require("hardhat");
const { getAccounts } = require("../hasbi");
const _bid = ethers.utils.parseEther("1");

let AUCTION, PROXY, BASIC;

async function bid(_BID) {
	console.log("Bidding...")
	BASIC = await ethers.getContract("BasicNFT");
	AUCTION = await ethers.getContract("Auction");
	const accounts = await ethers.getSigners();
	const tester = accounts[3];
	const tx = await AUCTION.connect(tester).bid(BASIC.address, _BID);
	await tx.wait(1);
	console.log(`${tester.address} bid ${_BID} for the ${BASIC.address} NFT`);
}

bid(_bid)
.then(() => process.exit(0))
.catch((error) => {
	console.error(error)
})