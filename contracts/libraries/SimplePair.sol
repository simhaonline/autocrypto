// SPDX-License-Identifier: GNU GPL-3.0-or-later
pragma solidity 0.8.10;

import "../interfaces/IPancakePair.sol";
import "../interfaces/IERC20.sol";
import "../interfaces/IWBNB.sol";

library SimplePair {
    IWBNB constant WBNB = IWBNB(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
    address private constant PANCAKE_FACTORY = 0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73;

    // executes a simple swap of tokens in this pair.
    // @amountIn is the amount you want to spend on the swap
    // @token is the address of one of the tokens in the pair, this token is the associated with the @amountIn
    // note: no previous checks are required, you only need to input a @amountIn that is avaliable and the token address that is in the pair
    // output amount and other calculations are handled by the function internally
    function simpleSwap(IPancakePair pair, address token, uint amountIn) internal returns (uint) {
        require(token == pair.token0() || token == pair.token1(), "!pair token");
        require(amountIn > 0, "!amountIn");

        if(token == address(WBNB)){
            depositWBNB(amountIn);
        }

        require(IERC20(token).balanceOf(address(this)) >= amountIn, "!balance");
        
        (uint reserve0, uint reserve1,) = pair.getReserves();

        (uint256 reserveA, uint256 reserveB) = 
            token == pair.token0()
            ? (reserve0, reserve1)
            : (reserve1, reserve0);

        uint amountOut = getAmountOut(amountIn, reserveA, reserveB);

        (uint256 amount0Out, uint256 amount1Out) = 
            token == pair.token0()
            ? (uint256(0), amountOut) 
            : (amountOut, uint256(0));

        IERC20(token).transfer(address(pair), amountIn); //send the input tokens to the pair contract to execute the swap
        pair.swap(amount0Out, amount1Out, address(this), new bytes(0));
        
        return amountOut;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        require(amountIn > 0, 'INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'INSUFFICIENT_LIQUIDITY');

        (uint m, uint n) = (1000,2); //m and n are the constants in the PancakePair contract for pancakeswap pairs
        uint amountInWithFee = amountIn * (m - n);
        uint numerator = amountInWithFee * reserveOut;
        uint denominator = reserveIn * m + amountInWithFee;
        amountOut = numerator / denominator;
    }
    
    //convert enough bnb into wbnb to reach @amountIn in wbnb ( only if the current amount of wbnb is less than @amountIn )
    function depositWBNB(uint amountIn) internal {
        uint wbnbBalance = WBNB.balanceOf(address(this));
        if(wbnbBalance >= amountIn) return; //the wbnb in the contract is sufficient for the swap

        uint bnbBalance = address(this).balance;
        require(wbnbBalance + bnbBalance >= amountIn, "not enough bnb");
            
        uint differenceNeeded = amountIn - wbnbBalance; // missing amount of wbnb required for the swap
        WBNB.deposit{value:differenceNeeded}();//convert bnb to wbnb 
    }

    //checks if the @token is present in the @pair
    function isOnPair(IPancakePair pair, address token) internal view returns (bool) {
        return pair.token0() == token || pair.token1() == token;
    }

    //returns the reserves for the @token in the @pair
    function reserve(IPancakePair pair, address token) internal view returns (uint) {
        (uint reserve0, uint reserve1,) = pair.getReserves();
        return token == pair.token0() ?reserve0 : reserve1;
    }
}
