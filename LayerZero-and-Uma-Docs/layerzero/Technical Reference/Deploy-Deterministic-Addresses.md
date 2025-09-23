# Deploy Deterministic Addresses

URL: https://docs.layerzero.network/v2/developers/evm/tooling/uniform-address

Version: Endpoint V2Deploy Deterministic AddressesDeploying the same OApp contract address on multiple chains can be useful for testing purposes and helpful to users interacting with your contracts across various networks.
Several methods exist to deploy the same contract address on multiple chains:
Traditional Method​
Typically, deploying a contract on different chains involves ensuring the deployer’s nonce is synchronized across these chains. However, the deployment process, often involving multiple transactions, can lead to nonce discrepancies which break the desired deployment.
CREATE2 Factory​
While CREATE2 allows for deterministic deployment of contracts, the resulting address depends on the hash of the contract's creation code. This implies that using different constructor parameters on various chains will result in different contract addresses.
CREATE3 Factory​
The CREATE3 factory improves on CREATE2 by determining the contract’s address solely based on the deployer's address and a salt value. This method significantly simplifies the deployment of contracts with the same address across multiple chains.
Read the CREATE3 Factory Docs.
CREATEX Factory​
CREATEX uses an advanced method for creating and deploying smart contracts with the same address. It's designed to streamline and secure the use of the CREATE and CREATE2 EVM opcodes for contract creation.
Read the CREATEX Factory Docs.

---
Note: This content was extracted from the LayerZero documentation. Tables and special components have been converted to plain text for better readability.
