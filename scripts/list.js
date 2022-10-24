const { deployments, ethers, getNamedAccounts } = require("hardhat");
const { getAccounts } = require("../hasbi");
let AUCTION, PROXY, BASIC;
const start = ethers.utils.parseEther("0.1");

async function list(_START) {
	console.log("Listing...");
	const accounts = await getAccounts();	
	const tester = accounts[1];
	AUCTION = await ethers.getContract("Auction");
	BASIC = await ethers.getContract("BasicNFT");
	console.log("Approving...");
	const tokenId = await BASIC.getCounter(tester.address);
	console.log(tokenId.toString());
	const tx = await BASIC.connect(tester).approve(AUCTION.address, tokenId);
	await tx.wait(1);	
	console.log("Approved")	
	await AUCTION.connect(tester).listNFT(BASIC.address, 0 , _START);
	console.log(`${tester.address} listed ${BASIC.address} for bidding starting price: ${_START}`);
}

list(start)
.then(() => process.exit(0))
.catch((error) => {
	console.error(error)
})   