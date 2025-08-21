// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {MultiGameMinter} from "../src/MultiGameMinter.sol";

contract DeployMultiGameMinter is Script {
    function run() external returns (MultiGameMinter) {
        // Load the private key from the .env file
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        require(deployerPrivateKey != 0, "PRIVATE_KEY not set in .env");

        
    }
}