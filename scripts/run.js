// No need to import ethers, can access it through Hardhat Runtime Environment, or 'HRE'

const main = async () => {
	// Compile our contract and generate the files needed to work with. Artifacts.
	const nftContractFactory = await hre.ethers.getContractFactory("EhrabNFT");
	// Deploy contract to local Ethereum network, new chain state every time, easier to debug errors
	const nftContract = await nftContractFactory.deploy();
	// Wait untill call to deploy() has resolved, constructor will run when contract is deployed
	await nftContract.deployed();
	// This will give us the address of the deployed contract
	console.log("Contract deployed to:", nftContract.address);

	// Call the function.
	let tx = await nftContract.mintEhrabNFT();
	// Wait for it to be mined.
	await tx.wait();

	// Mint another NFT for fun.
	tx = await nftContract.mintEhrabNFT();
	// Wait for it to be mined.
	await tx.wait();
};

const runMain = async () => {
	try {
		await main();
		process.exit(0);
	} catch (error) {
		console.log(error);
		process.exit(1);
	}
};

runMain();
