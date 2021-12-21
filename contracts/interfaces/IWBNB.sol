// SPDX-License-Identifier: GNU GPL-3.0-or-later
pragma solidity 0.8.10;

interface IWBNB {
    function deposit() external payable;
    function withdraw(uint value) external;
    function balanceOf(address owner) external view returns (uint);
    function transfer(address to, uint value) external returns (bool);
}