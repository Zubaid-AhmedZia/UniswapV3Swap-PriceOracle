require("@nomiclabs/hardhat-waffle");
//require('@openzeppelin/hardhat-upgrades');
require("@nomiclabs/hardhat-ethers");

require("@nomiclabs/hardhat-etherscan");
//import '@openzeppelin/hardhat-upgrades';


// Go to https://www.alchemyapi.io, sign up, create
// a new App in its dashboard, and replace "KEY" with its key
const ALCHEMY_API_KEY = "";

// Replace this private key with your Ropsten account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Be aware of NEVER putting real Ether into testing accounts
const RINKEBY_PRIVATE_KEY = "";

module.exports = {
  solidity: "0.7.0",
  networks: { 
    ropsten: {
      url: `https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [`${RINKEBY_PRIVATE_KEY}`]
    }
  },
  etherscan: {
    apiKey: ""
  }
};


// require("@nomiclabs/hardhat-waffle")

// // This is a sample Hardhat task. To learn how to create your own go to
// // https://hardhat.org/guides/create-task.html
// task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
//   const accounts = await hre.ethers.getSigners()

//   for (const account of accounts) {
//     console.log(account.address)
//   }
// })

// // You need to export an object to set up your config
// // Go to https://hardhat.org/config/ to learn more

// /**
//  * @type import('hardhat/config').HardhatUserConfig
//  */
// module.exports = {
//   solidity: "0.7.0",
//   networks: {
//     localhost: {
//       url: "http://127.0.0.1:8545",
//     },
//     // hardhat: {
//     //   forking: {
//     //     url: `https://eth-mainnet.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`,
//     //   },
//     // },
//   },
// }