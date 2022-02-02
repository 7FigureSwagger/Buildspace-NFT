require('dotenv').config()
console.log(process.env)
require("@nomiclabs/hardhat-waffle");


// This is a sample Hardhat task. To learn how to create more go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
  solidity: "0.8.0",
	networks: {
		rinkeby: {
			url: process.env.ALCHEMY_API_KEY,
			accounts: [process.env.RINKEBY_ACCOUNT_KEY]
		}
	}
};
