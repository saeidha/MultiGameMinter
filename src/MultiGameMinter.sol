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

    // --- New Random Game Functions ---
    // WARNING: The randomness used here is pseudo-random and not secure for high-value applications.
    // It is based on block variables and is suitable for low-stakes games.

    /**
     * @dev Game 1: Sends ETH to get a random amount of tokens between 0 and 9.
     */
    function playSimpleGamble() public payable {
        require(msg.value > 0, "You must send some ETH to play.");
        uint256 pseudoRandom = _generateRandom(1);
        balances[msg.sender] += pseudoRandom % 10; // 0-9 tokens
    }

    /**
     * @dev Game 2: A small bet for a random amount between 10 and 19.
     */
    function playShiftedGamble() public payable {
        require(msg.value >= 0.001 ether, "Minimum bet is 0.001 ETH.");
        uint256 pseudoRandom = _generateRandom(2);
        balances[msg.sender] += (pseudoRandom % 10) + 10; // 10-19 tokens
    }

    /**
     * @dev Game 3: High risk, high reward. 10% chance to win 100 tokens, 90% chance to win 1.
     */
    function playHighReward() public payable {
        require(msg.value >= 0.002 ether, "Minimum bet is 0.002 ETH.");
        uint256 pseudoRandom = _generateRandom(3);
        if (pseudoRandom % 10 == 0) { // 10% chance
            balances[msg.sender] += 100;
        } else {
            balances[msg.sender] += 1;
        }
    }

    /**
     * @dev Game 4: Even or odd. Win 25 tokens on even, 5 on odd.
     */
    function playEvenOrOdd() public payable {
        require(msg.value >= 0.001 ether, "Minimum bet is 0.001 ETH.");
        uint256 pseudoRandom = _generateRandom(4);
        if (pseudoRandom % 2 == 0) { // Even
            balances[msg.sender] += 25;
        } else { // Odd
            balances[msg.sender] += 5;
        }
    }

    /**
     * @dev Game 5: The higher the random number, the smaller the prize.
     */
    function playInvertedDice() public payable {
        require(msg.value > 0, "You must send some ETH to play.");
        uint256 pseudoRandom = _generateRandom(5);
        uint256 roll = (pseudoRandom % 20) + 1; // 1-20
        balances[msg.sender] += (21 - roll); // If roll is 1, win 20. If roll is 20, win 1.
    }

    /**
     * @dev Game 6: A jackpot game. 1% chance to win 1000 tokens.
     */
    function playJackpot() public payable {
        require(msg.value >= 0.005 ether, "Minimum bet is 0.005 ETH.");
        uint256 pseudoRandom = _generateRandom(6);
        if (pseudoRandom % 100 == 77) { // 1% chance (matching a specific number)
            balances[msg.sender] += 1000;
        } else {
            balances[msg.sender] += 2;
        }
    }
    
    /**
     * @dev Game 7: Multiplier. Get 1 to 5 times your bet in tokens (based on a 0.001 ETH rate).
     */
    function playMultiplier() public payable {
        require(msg.value >= TOKEN_RATE, "Minimum bet is 0.001 ETH.");
        uint256 baseAmount = msg.value / TOKEN_RATE;
        uint256 pseudoRandom = _generateRandom(7);
        uint256 multiplier = (pseudoRandom % 5) + 1; // 1x to 5x
        balances[msg.sender] += baseAmount * multiplier;
    }
    
    /**
     * @dev Game 8: Get a random power of 2, from 2^0 to 2^7.
     */
    function playPowerOfTwo() public payable {
        require(msg.value >= 0.001 ether, "Minimum bet is 0.001 ETH.");
        uint256 pseudoRandom = _generateRandom(8);
        uint256 exponent = pseudoRandom % 8; // 0 to 7
        balances[msg.sender] += (2 ** exponent); // 1, 2, 4, 8, 16, 32, 64, 128
    }

    /**
     * @dev Game 9: All or nothing. 50% chance to win 50 tokens, 50% chance to win nothing.
     */
    function playAllOrNothing() public payable {
        require(msg.value >= 0.002 ether, "Minimum bet is 0.002 ETH.");
        uint256 pseudoRandom = _generateRandom(9);
        if (pseudoRandom % 2 == 1) {
             balances[msg.sender] += 50;
        }
        // If it's 0, they get nothing.
    }

    /**
     * @dev Game 10: Low volatility. Always win between 5 and 10 tokens.
     */
    function playSafeBet() public payable {
        require(msg.value >= 0.001 ether, "Minimum bet is 0.001 ETH.");
        uint256 pseudoRandom = _generateRandom(10);
        balances[msg.sender] += (pseudoRandom % 6) + 5; // 5-10 tokens
    }


    // --- Utility and Administrative Functions ---

    /**
     * @dev Internal function to generate a pseudo-random number.
     * Uses a salt to ensure different functions produce different results in the same block.
     */
    function _generateRandom(uint256 salt) private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender, salt)));
    }
    
    /**
     * @dev Allows the owner to withdraw the entire ETH balance of the contract.
     */
    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw.");
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "Withdrawal failed.");
    }
}