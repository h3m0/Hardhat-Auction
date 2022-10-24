const { ethers } = require("hardhat");
const { getAccounts } = require("../hasbi");
let AUCTION, PROXY, BASIC;

async function mint() {
	console.log("Minting...");
	const accounts = await getAccounts();
	const tester = accounts[1];
	BASIC = await ethers.getContract("BasicNFT");
	const tx = await BASIC.connect(tester).mintNFT();
	await tx.wait(1);
	const tokenId = await BASIC.getCounter(tester.address);
	console.log(`${BASIC.address} minted to: ${tester.address}, tokenId: ${tokenId}`);
}

mint()
.then(() => process.exit(0))
.catch((error) => {
		console.error(error)
	}
)
