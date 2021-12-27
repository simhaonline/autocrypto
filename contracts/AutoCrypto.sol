// SPDX-License-Identifier: GNU GPL-3.0-or-later
pragma solidity 0.8.10;

import "./libraries/SimplePair.sol";
import "./libraries/SimpleOwner.sol";
import "./interfaces/IPancakePair.sol";
import "./interfaces/IPancakeFactory.sol";

contract AutoCrypto is SimpleOwner{
    using SimplePair for IPancakePair;

    IPancakeFactory private constant PANCAKE_FACTORY = IPancakeFactory(0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73);

    //returns the address of the pair (if it exists) on pancakeswap for the provided tokens 
    function getPair(address token0, address token1) external view returns (address pair) {
        require(token0 != token1,"token0 != token1");
        pair = PANCAKE_FACTORY.getPair(token0, token1);
        require (pair != address(0), "pair not found");
    }
    
    // swaps two tokens in the provided pair
    function swap(address _pair, address inToken, uint amount) external onlyOwner returns (uint amountOut) {
        require(_pair != address(0), "!pair");
        IPancakePair pair = IPancakePair(_pair);
        require(pair.isOnPair(inToken), "!isOnPair");
        amountOut = pair.simpleSwap(inToken, amount);
    }

    function number() external pure returns(uint){
        return 1;
    }
}