const { expect } = require("chai")
const { ethers } = require("hardhat")

const FACTORY = "0x1F98431c8aD98523631AE4a59f267346ea31F984"
// USDC
const TOKEN_0 = "0xeb8f08a975Ab53E34D8a0330E0D34de942C95926"
const DECIMALS_0 = 6n
// WETH
const TOKEN_1 = "0xc778417E063141139Fce010982780140Aa0cD5Ab"
const DECIMALS_1 = 18n
// 0.3%
const FEE = 3000
// Pair
// 0x8ad599c3A0ff1De082011EFDDc58f1908eb6e6D8

ROUTER = "0xE592427A0AEce92De3Edee1F18E0157C05861564"

describe("UniswapV3Twap", () => {
  it("get price", async () => {
    
    const UniswapV3Twap = await ethers.getContractFactory("UniswapV3Twap")
    const twap = await UniswapV3Twap.deploy(FACTORY, TOKEN_0, TOKEN_1, FEE)
    await twap.deployed()

    console.log("deployed");

    const price = await twap.estimateAmountOut(TOKEN_1, 10n ** DECIMALS_1, 10)

    console.log(`price: ${price}`)
  })
})

describe("SwapExamplesOG", () => {
  it("get swap", async () => {
    
    const v3Swap = await ethers.getContractAt("SwapExamplesOG","0x919250D062e79a87989646C29dc697B71670fdc5")

    const amountOut = await v3Swap.swapExactInputSingle(10n ** DECIMALS_1)

    console.log(`amountOut: ${amountOut}`) 
  })
})