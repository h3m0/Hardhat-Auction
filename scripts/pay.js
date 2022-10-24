const { ethers } = require("hardhat");
let AUCTION, PROXY, BASIC;

async function pay(_NFT_ADDRESS) {
	const accounts = await ethers.getSigners();
	const tester = accounts[3];
	const tx = await AUCTION.connect(tester).pay(_NFT_ADDRESS);
	await tx.wait(1);
}

pay()
.then(() => process.exit(0))
.catch((error) => {
		console.error(error)
	}
)
