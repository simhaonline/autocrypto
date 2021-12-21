// SPDX-License-Identifier: GNU GPL-3.0-or-later
pragma solidity 0.8.10;

import "./IERC20.sol";

// Simple Owner defines a contract with single owner that cannot be changed
// this contract can receive funds and has the ability to transfer funds to the owners address only
abstract contract SimpleOwner {
    address payable immutable internal owner;

    // Only owner should be able to run functions
    modifier onlyOwner() {
        require(msg.sender == owner, "!owner");
        _;
    }

    constructor() {
        owner = payable(msg.sender);
    }

    // withdraw all bnb in this contract to the owner address 
    function withdraw() external onlyOwner {
        owner.transfer(address(this).balance);
    }

    // withdraw all of the token provided in this contract to the owner address 
    function withdrawToken(address tokenAddr) external onlyOwner{
        IERC20 token = IERC20(tokenAddr); 
        uint amount = token.balanceOf(address(this));
        token.transfer(owner, amount);
    }

    receive() external payable {}

    fallback() external payable {}
}