const { getNamedAccounts, deployments, ethers, network } = require("hardhat");

module.exports = async () => {
	const { deploy, log } = deployments;
	const chainId = network.config.chainId;
	const { deployer, tester, tester2, tester3 } = await getNamedAccounts();

	const PROXY = await deploy(
		"proxy", {
			from: deployer,
			log: true,
			args: [],
			contract: "proxy"
		}
	)
}