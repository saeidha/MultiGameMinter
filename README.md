# MultiGameMinter Smart Contract

A simple and gas-efficient Solidity smart contract that allows users to acquire a non-transferable token either at a fixed, predictable rate or by playing one of ten different pseudo-random games.

## Overview

This contract manages an internal, non-transferable token system. It offers two primary ways for users to increase their token balance:

1.  **Fixed-Rate Minting:** A predictable method where users send ETH and receive a corresponding amount of tokens based on a constant rate.
2.  **Random Games:** A suite of ten unique, payable "gamble" functions that award variable amounts of tokens based on a pseudo-random outcome.

The contract is designed to be lightweight, minimizing gas costs for users while providing varied functionality. The tokens themselves are "soulbound" in nature, meaning they are tied to the user's address and cannot be traded or transferred.

## Features

-   **Non-Transferable Token:** Tokens exist only as balances within the contract (`mapping(address => uint256)`) and cannot be sent to other users.
-   **Deterministic Minting:** A reliable way to get tokens at a fixed ETH price using the `mintTokens()` function.
-   **10 Unique Random Games:** A variety of payable functions (`playSimpleGamble`, `playJackpot`, etc.) with different rules, costs, and reward structures.
-   **Gas Optimized:** Designed with simple logic and minimal state changes to keep transaction fees low.
-   **Ownable:** The contract has an `owner` who is the only one authorized to withdraw the accumulated ETH from the contract balance.

## Core Functions

### Deterministic Minting

#### `mintTokens()`
This `payable` function is the standard way to acquire tokens. Users send ETH, and the contract mints tokens for them at the predefined `TOKEN_RATE`.
-   **Rate:** `1 token` per `0.001 ETH`.
-   **Outcome:** Predictable and non-random.

### Random Game Functions

This contract includes 10 different `payable` game functions, each providing a unique risk/reward mechanic.

-   `playSimpleGamble()`: Win a random amount from 0-9 tokens.
-   `playShiftedGamble()`: Win a random amount from 10-19 tokens.
-   `playHighReward()`: A 10% chance to win 100 tokens, otherwise win 1.
-   `playEvenOrOdd()`: Win 25 tokens for an "even" roll, 5 for "odd".
-   `playInvertedDice()`: A higher random roll results in a lower prize.
-   `playJackpot()`: A 1% chance to win a 1000-token jackpot.
-   `playMultiplier()`: Multiply your base token purchase by 1x to 5x.
-   `playPowerOfTwo()`: Win a random power of two (1, 2, 4, ..., 128).
-   `playAllOrNothing()`: A 50/50 chance to win 50 tokens or nothing.
-   `playSafeBet()`: A low-volatility game that always rewards 5-10 tokens.

### Administrative Functions

#### `withdraw()`
An owner-only function. The contract deployer (`owner`) can call this function to transfer the contract's entire accumulated ETH balance to their own address.

## Security & Important Considerations

### **Disclaimer on Randomness**

The random number generation in the game functions is based on block variables like `block.timestamp` and `block.prevrandao`. **This method is NOT cryptographically secure** and is vulnerable to manipulation by blockchain miners. It is intended only for low-stakes, entertainment-oriented applications where the tokens have no real-world financial value. **DO NOT use this logic for high-value gambling or applications requiring true randomness.**

### **Token Nature**

The tokens minted by this contract are internal accounting units. They **cannot be traded, sold, or transferred** to other users. They have no value outside of this contract's ecosystem.

### **Ownership**

The contract is ownable. Ensure that the deploying address is a secure wallet that you control, as it will be the only address capable of withdrawing funds.

## How to Use

1.  **Compile:** Use a Solidity compiler compatible with version `^0.8.20` (e.g., in Remix, Hardhat, or Foundry).
2.  **Deploy:** Deploy the `MultiGameMinter.sol` contract to an EVM-compatible network. The address that deploys the contract will automatically be set as the `owner`.
3.  **Interact:**
    -   To mint tokens predictably, call `mintTokens()` and send ETH as `msg.value`.
    -   To play a game, call one of the ten `play...()` functions and send the required ETH.
4.  **Withdraw Funds:** As the owner, call the `withdraw()` function to collect the ETH paid by users.

## License

This smart contract is released under the [MIT License](https://opensource.org/licenses/MIT).