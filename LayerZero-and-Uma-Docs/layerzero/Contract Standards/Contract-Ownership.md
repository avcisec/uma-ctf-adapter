# Best Practices for Contract Ownership

URL: https://docs.layerzero.network/v2/developers/evm/technical-reference/transfer-ownership

Version: Endpoint V2Best Practices for Contract OwnershipLayerZero’s Contract Standards inherit the OpenZeppelin Ownable Standard by default. This allows for flexible and secure administration of deployed contracts, such as OApp or OFT. However, decisions around transferring or renouncing ownership must be made carefully, especially when dealing with critical contracts.
Why Ownership Matters​
When you deploy a contract, such as an OFT token, the deployer is set as the initial owner. As the owner, you have the ability to configure many administrative settings, including:• Peer Management: Setting peers for cross-chain operations.
• Delegate Controls: Managing delegate addresses.
• Enforced Options: Configuring options that govern contract behavior.
• Message Inspectors: Overseeing message processing and security checks.These controls are essential for ensuring the secure operation of your LayerZero contracts.
Recommended Best Practices​1. Retain Ownership with a Secure Multisig:• Do not renounce ownership of critical contracts like the OFT. Instead, transfer ownership to a multisig wallet.
• A multisig setup requires multiple signatures (or approvals) for administrative actions, reducing the risk of a single point of failure.
• Use a high enough quorum to ensure that no single party can unilaterally change settings.
2. Maintain Flexibility:• Retaining ownership allows you to adjust peers, delegates, and other settings as your cross-chain protocols evolve.
• This flexibility can be critical for adding new networks or responding to chain level disruptions.
3. Document and Audit:• Clearly document the ownership and administration process for your contracts.
• Regularly audit the multisig wallet and its quorum settings to ensure they meet current security and governance standards.Example: Transfer of Ownership​
LayerZero’s contracts follow the Ownable pattern. For example, here’s how you can transfer ownership of an OFT token contract:```
// SPDX-License-Identifier: UNLICENSEDpragma solidity ^0.8.22;import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";import { OFT } from "@layerzerolabs/oft-evm/contracts/OFT.sol";contract MyOFT is OFT, Ownable {    constructor(        string memory _name,        string memory _symbol,        address _lzEndpoint,        address _delegate    ) OFT(_name, _symbol, _lzEndpoint, _delegate) Ownable(_delegate) {}}
``````
// Transferring ownership in your deployment script or via a web3 interface:tx = await(await oft.transferOwnership(newAddress)).wait();
```By transferring ownership to a secure multisig wallet (or another trusted address), you ensure that the contract remains under strong administrative control even as you delegate responsibilities or make system-wide changes.
Summary​• Retain Ownership: Do not renounce ownership on critical LayerZero contracts (like the BNB OFT token).
• Use Secure Multisig: Always maintain ownership through a properly configured multisig wallet to allow for necessary administrative controls.
• Stay Flexible: Keeping control allows you to update settings such as peers, delegates, and message inspectors as needed.This approach secures your contract administration while ensuring you can respond to any changes or issues that arise in a rapidly evolving cross-chain environment.

---
Note: This content was extracted from the LayerZero documentation. Tables and special components have been converted to plain text for better readability.
