const { getNamedAccounts, deployments, ethers, network } = require("hardhat")

module.exports = async () => {
	const { deploy, log } = deployments;
	const { deployer, tester1, tester2, tester3 } = await getNamedAccounts();
	const chainId = network.config.chainId;
	let AUCTION;

	console.log("==========================================");
	console.log("Deploying NFT Auction...");
	AUCTION = await deploy(
		"Auction", {
			from: deployer,
			args: [],
			contract: "Auction",
			log: true
		}
	)
	console.log("==========================================");
	console.log(`Auction deployed at: ${AUCTION.address}`);
}