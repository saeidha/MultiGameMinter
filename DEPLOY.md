# Make sure your .env file is loaded
source .env

# Run the script to deploy and verify on Sepolia
forge script script/DeployMultiGameMinter.s.sol:DeployMultiGameMinter \
--rpc-url $RPC_URL \
--private-key $PRIVATE_KEY \
--etherscan-api-key $ETHERSCAN_API_KEY \
--broadcast \
--verify \
-vvvv