// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MultiGameMinter
 * @author Saeidha
 * @dev A gas-efficient contract where users can either mint a fixed amount of a
 * non-transferable token by sending ETH, or play various random games to win tokens.
 */
contract MultiGameMinter {

    // This mapping acts as a ledger for the non-transferable token.
    // It maps a user's address to their token balance.
    mapping(address => uint256) public balances;

    // The address of the contract owner, set during deployment.
    address public owner;

    // The conversion rate for the deterministic minting function: 1 token per 0.001 ETH.
    // This is a constant and visible to everyone.
    uint256 public constant TOKEN_RATE = 0.001 ether;

    /**
     * @dev The constructor sets the contract deployer as the owner.
     */
    constructor() {
        owner = msg.sender;
    }

    // --- Core Deterministic Minting Function ---

    /**
     * @dev Allows a user to mint tokens at a fixed rate by sending ETH.
     * This function is predictable and not random.
     */
    function mintTokens() public payable {
        // Require the sent ETH to be at least enough for one token.
        require(msg.value >= TOKEN_RATE, "You must send at least 0.001 ETH.");

        // Calculate the amount of tokens to mint based on the sent ETH and the fixed rate.
        // Integer division in Solidity discards the remainder.
        uint256 amountToMint = msg.value / TOKEN_RATE;

        // Increase the user's token balance.
        balances[msg.sender] += amountToMint;
    }
