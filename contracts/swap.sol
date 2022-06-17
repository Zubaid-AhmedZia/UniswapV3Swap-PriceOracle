// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.7.0;
//pragma abicoder v2;
pragma experimental ABIEncoderV2;
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
//import '@openzeppelin/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
contract SwapExamplesOG is ERC20{
    // For the scope of these swap examples,
    // we will detail the design considerations when using `exactInput`, `exactInputSingle`, `exactOutput`, and  `exactOutputSingle`.
    // It should be noted that for the sake of these examples we pass in the swap router as a constructor argument instead of inheriting it.
    // More advanced example contracts will detail how to inherit the swap router safely.
    // This example swaps DAI/WETH9 for single path swaps and DAI/USDC/WETH9 for multi path swaps.
    ISwapRouter public immutable swapRouter;
    //0xE592427A0AEce92De3Edee1F18E0157C05861564 router
    address public constant DAI = 0xc7AD46e0b8a400Bb3C915120d284AafbA8fc4735;
    address public constant WETH9 = 0xc778417E063141139Fce010982780140Aa0cD5Ab;
    address public constant USDC = 0xeb8f08a975Ab53E34D8a0330E0D34de942C95926;
    // address public constant USDC = 0x0d72c7f787c0Ee5ea6347bAaCD1d030460d5cAb5; //tkn1
    // address public constant WETH9 = 0xc778417E063141139Fce010982780140Aa0cD5Ab;
    // address public constant USDT = 0x953c5C6510C673f58d9f9c6328d0Bc1155dcb558; //tknB
    // For this example, we will set the pool fee to 0.3%.
    uint24 public constant poolFee = 3000;
    constructor(ISwapRouter _swapRouter) ERC20("abc", "a"){
        swapRouter = _swapRouter;
        // ERC20 token1 = ERC20(0x0d72c7f787c0Ee5ea6347bAaCD1d030460d5cAb5);
        // token1.approve(address(this), 10000000000000000000000000);
    }
    IERC20 token = IERC20(0xc7AD46e0b8a400Bb3C915120d284AafbA8fc4735);
    ERC20 token1 = ERC20(0xc7AD46e0b8a400Bb3C915120d284AafbA8fc4735);

    function approveThisContract(uint amount) external returns (bool) {
       return token.approve(address(this), amount);
        
    }


    function checkAllowance(address owner, address spender) external view returns (uint){
        return token.allowance(owner, spender);
    }
    //token.approve(address(this), amountIn);

    //token.approve(address(this), 1000000000000000000000000000000000000000);
   /// @notice swapExactInputSingle swaps a fixed amount of DAI for a maximum possible amount of WETH9
    /// using the DAI/WETH9 0.3% pool by calling `exactInputSingle` in the swap router.
    /// @dev The calling address must approve this contract to spendn at least `amountIn` worth of its DAI for this function to succeed.
    /// @param amountIn The exact amount of DAI that will be swapped for WETH9.
    /// @return amountOut The amount of WETH9 received.
    function swapExactInputSingle(uint256 amountIn) external returns (uint256 amountOut) {
        // msg.sender must approve this contract
        //token.approve(address(this), amountIn);
        // Transfer the specified amount of DAI to this contract.
        token.transferFrom(msg.sender, address(this), amountIn);
        // Approve the router to spend DAI.
        token.approve(address(swapRouter), amountIn);
  // Naively set amountOutMinimum to 0. In production, use an oracle or other data source to choose a safer value for amountOutMinimum.
        // We also set the sqrtPriceLimitx96 to be 0 to ensure we swap our exact input amount.
        ISwapRouter.ExactInputSingleParams memory params =
        ISwapRouter.ExactInputSingleParams({
                tokenIn: DAI,
                tokenOut: USDC,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });     
        // The call to `exactInputSingle` executes the swap.
        amountOut = swapRouter.exactInputSingle(params);
    }
      /// @notice swapExactOutputSingle swaps a minimum possible amount of DAI for a fixed amount of WETH.
/// @dev The calling address must approve this contract to spend its DAI for this function to succeed. As the amount of input DAI is variable,
/// the calling address will need to approve for a slightly higher amount, anticipating some variance.
/// @param amountOut The exact amount of WETH9 to receive from the swap.
/// @param amountInMaximum The amount of DAI we are willing to spend to receive the specified amount of WETH9.
/// @return amountIn The amount of DAI actually spent in the swap.
function swapExactOutputSingle(uint256 amountOut, uint256 amountInMaximum) external returns (uint256 amountIn) {
// Transfer the specified amount of DAI to this contract.
token.transferFrom(msg.sender, address(this), amountInMaximum);
        // Approve the router to spend the specified `amountInMaximum` of DAI.
        // In production, you should choose the maximum amount to spend based on oracles or other data sources to achieve a better swap.
        token.approve(address(swapRouter), amountInMaximum);
        ISwapRouter.ExactOutputSingleParams memory params =
            ISwapRouter.ExactOutputSingleParams({
                tokenIn: DAI,
                tokenOut: USDC,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: amountOut,
                amountInMaximum: amountInMaximum,
                sqrtPriceLimitX96: 0
            });
        // Executes the swap returning the amountIn needed to spend to receive the desired amountOut.
        amountIn = swapRouter.exactOutputSingle(params);
        // For exact output swaps, the amountInMaximum may not have all been spent.
        // If the actual amount spent (amountIn) is less than the specified maximum amount, we must refund the msg.sender and approve the swapRouter to spend 0.
        if (amountIn < amountInMaximum) {
            token.approve(address(swapRouter), 0);
            token.transfer(msg.sender, amountInMaximum - amountIn);
        }
    }

    }
