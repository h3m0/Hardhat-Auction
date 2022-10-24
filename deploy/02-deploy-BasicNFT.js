const { ethers, deployments, getNamedAccounts } = require('hardhat');

module.exports = async () => {
	const { deploy, log } = deployments;
	const { deployer } = await getNamedAccounts();		
	log("=================================================");
	const BASIC = await deploy("BasicNFT", {
		from: deployer,
		log: true,
		contract: "BasicNFT",
		waitConfirmations: 1
	})
	log("=================================================");
}