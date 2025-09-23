# LayerZero EVM Chain Compatibility

URL: https://docs.layerzero.network/v2/developers/evm/evm-variants/evm-compatible-variants

Version: Endpoint V2LayerZero EVM Chain CompatibilityLayerZero V2 connects a diverse ecosystem of blockchain networks that support Ethereum's Virtual Machine (EVM). Because different chains implement the EVM in various ways, it's important for developers—especially those building omnichain applications (OApp), OFT, and ONFT—to understand whether a network is EVM Compatible or EVM Equivalent.
This documentation focuses on the practical impacts when integrating LayerZero:• Fee delivery: LayerZero endpoints expect worker fees to be delivered via payable (msg.value) using the chain's native token. Some chains (e.g. SKALE) use an alternative ERC20 fee token, which requires alternative LayerZero contracts (e.g., EndpointV2Alt, OAppAlt, OFTAlt).
• Token standards: LayerZero EVM token standards rely on the normal ERC20/ERC721 conventions.
• Data queries (lzRead): LayerZero Read functions may use block.number and block.timestamp to reference "latest" state. However, on some chains these values may drift or be unreliable (for example, Arbitrum's block.number may return the L1 block number), potentially causing mismatches in state queries.
• Gas estimation: Accurate gas limits are critical to ensure successful cross-chain message delivery. Each chain may have a unique fee model, which impacts how gas estimates should be calculated for lzReceive and lzCompose.Concept: Compatibility vs. Equivalence​EVM compatibility:
While these chains run Ethereum smart contracts, they may require adjustments in deployment scripts, fee handling, gas estimation, and verification. For example, zkSync requires its own compiler (zkSolc), and SKALE's "free gas" model requires an alternative fee token for cross-chain fees. These differences can affect how LayerZero contracts pay/receive fees and how developers should interact with the chain.
EVM equivalence:
These chains replicate Ethereum's execution environment so closely that standard clients, deployment scripts, and tooling work without modification. Most LayerZero integrations (like OApp/OFT/ONFT and lzRead queries) work as on Ethereum—with only subtle differences.These differences directly impact:• Fee payment: Standard msg.value fee delivery is expected by LayerZero endpoints. Some chains, however, require alternative tokens or extra configuration.
• On-chain data: lzRead can depend on block.number and block.timestamp. Variability or drift in these values (for instance, Arbitrum may return L1 block.number) may result in inaccurate or outdated state queries.
• Gas management: Accurate gas limits must be set to ensure lzReceive and lzCompose execution succeeds across chains.Detailed Chain-Specific Overviews​
Below is a summary for each chain type with key impacts for LayerZero integrations and links to more documentation.
EVM Diff CheckerFor a quick way to identify opcode differences between networks, check out the EVM Diff Checker. This tool is particularly useful if you're troubleshooting or optimizing across various EVM implementations.
Optimism (OP) Stack: EVM Equivalence​
OP Stack chains aim for out-of-the-box Ethereum compatibility. You can use standard Ethereum tools and wallets without modification​.
Examples:• Optimism, BaseKey details for LayerZero:• Toolchain & compilers:
Use standard Ethereum tools and the regular Solidity compiler.
Optimism Docs – Differences
• Fee payment:
Fees are paid in ETH via msg.value with no alternative fee token needed.
• On-chain reads:
Block.number and block.timestamp behave similarly to Ethereum, with a fixed ~2-second block time.
• Further documentation:
Optimism DocumentationArbitrum Orbit: EVM Equivalence​
Arbitrum uses normal EVM bytecode (Arbitrum Nitro incorporates the Ethereum Yellow Paper spec), meaning you can compile with the same solc version you'd use on Ethereum mainnet.
Examples:• Arbitrum One, Arbitrum Nova, ApeChain (Orbit)Key details for LayerZero:• Toolchain & compilers:
Standard Ethereum tools work; no special compiler is needed.
Arbitrum Developer Portal
• Fee payment:
On Arbitrum One/Nova, fees are paid in ETH (or bridged ArbETH). However, some Orbit chains may use a custom ERC20 (e.g. APE on ApeChain).
• On-chain reads:
Arbitrum's block.number may reflect L1's block number, and its flexible sequencer-controlled block.timestamp can potentially drift by up to 24 hours in the past or 1 hour in the future. In the worst case scenario, this variability may cause lzRead to return historical or mismatched state.
Arbitrum Docs – Arbitrum vs Ethereum
• Further documentation:
Arbitrum Developer DocumentationAvalanche Subnet: EVM Equivalent​
Avalanche subnets that run the EVM (Subnet-EVM) allow you to use the same Ethereum development tools as expected. By default, Avalanche's Subnet-EVM does not remove or alter EVM opcodes – it's EVM-equivalent.
infoAvalanche subnets can have custom fee tokens and models. By default, when you create a subnet EVM, you specify the native token (it could be an existing ERC20 or a new token created as the native asset).
Examples:• Avalanche, Dexalot, DeFi KingdomKey details for LayerZero:• Toolchain & compilers:
Use standard Ethereum development tools with the subnet's RPC and chain ID.
• Fee payment:
Fees are paid in the subnet's native token (AVAX or a custom token). Make sure your msg.value fee delivery aligns with the chain's requirements. You may need OFTAlt if the Subnet requires a custom ERC20 token for fees.
• On-chain reads:
block.number and block.timestamp update more frequently (typically 1–2 seconds per block) compared to Ethereum. This faster cadence can affect lzRead if your contracts assume Ethereum-like intervals.
• Further documentation:
Avalanche Subnets DocszkSync Elastic Chains: EVM Compatible​
zkSync Era is a ZK-rollup that supports Solidity, but you should use zkSync's provided tooling for the smoothest experience. Incorporate Matter Labs' toolchain additions: use zksolc compiler, and the specialized Hardhat or Foundry integration​ for a frictionless dev experience.
Examples:• zkSync Era, AbstractKey details for LayerZero:• Toolchain & compilers:
Use zkSync's Hardhat or Foundry plugin with the zksolc compiler.
• Fee payment:
Fees are paid in msg.value, with no alternative fee token needed.
• On-chain reads:
Due to rollup batching, block.number and block.timestamp may jump in batches rather than update continuously. This requires careful handling in lzRead to ensure you query the intended state.
• Further documentation:
zkSync Era DocumentationSKALE: EVM Compatible​
SKALE is a multi-chain network where each chain is an EVM-compatible blockchain (often called an "Elastic Sidechain"). For deploying and interacting with contracts on a SKALE chain, you mostly use standard Ethereum tools – with a couple of caveats due to network specifics.
Examples:• SKALEKey details for LayerZero:• Toolchain & compilers:
Standard Ethereum tools work, with configuration changes for SKALE's RPC and chain ID.
SKALE Network Differences
• Fee payment:
SKALE uses a "free gas" model with a dummy token (sFUEL). However, LayerZero workers require an alternative ERC20 token to handle destination gas payments. The LayerZero Endpoint will expect fee delivery in this token rather than msg.value. For more information see OFT Alt.
• On-chain reads:
Block.number and block.timestamp are generally reliable, but note that gas fees aren't paid in ETH.
• Further documentation:
SKALE DocumentationBTC L2 Chains: EVM Compatible​
Most BTC L2s are EVM‑compatible. You can generally use standard Ethereum development tools and can compile with standard solc.
Examples:• GOAT, Rootstock, Bitlayer, Bouncebit, Citrea, and CornKey details for LayerZero:• Toolchain & compilers:
Standard Ethereum tools work, but may vary from L2 to L2.
• Fee payment:
Fees are paid in RBTC on RSK or zBTC on GOAT. LayerZero endpoints must receive fees in the proper native token.
• On-chain reads:
block.timestamp and block.number may differ substantially from Ethereum (e.g., RSK's ~30-second blocks). In GOAT, state finality depends on Bitcoin settlement; this could impact lzRead if using local chain data.
• Further documentation:
Rootstock Documentation | GOAT Network Documentation | Bitlayer Documentation | Corn DocumentationHyperEVM: EVM Equivalence​
Key details for LayerZero:• Toolchain & compilers:
Use standard Ethereum tools (Hardhat, ethers.js) with HyperEVM's RPC and chain ID.
HyperLiquid Docs
• Fee payment:
Fees are paid in HYPE (HyperLiquid's native token). Your LayerZero endpoints will expect msg.value in HYPE. Note the dual-block architecture may require higher gas limits for heavy transactions.
• Contract Standards:
While the normal OApp/OFT/ONFT can be used out-of-the-box on the HyperEVM, you will want to deploy a custom HyperOFT to have automatic delivery to the Hyperliquid Spot. See the HyperOFT documentation for more information.
• On-chain reads:
While HyperEVM's block.timestamp and block.number behave similarly to Ethereum's, the dual-block design (small vs. big blocks) may introduce discrepancies—especially if a heavy transaction is scheduled in a "big" block.
• Further documentation:
HyperLiquid HyperEVM DocumentationBelow are separate sections for Hedera and Tron, with additional detail on Hedera's unique requirements. In Hedera's case, many DeFi protocols use the Hedera Token Service (HTS) rather than a standard ERC20, which can necessitate custom contract changes when integrating with LayerZero.
Hedera: EVM Compatible​
Hedera is a public distributed ledger built on Hashgraph consensus that supports high-speed, fair, and secure transactions while also offering an EVM-compatible environment via the Hedera EVM.
Key details for LayerZero:• Toolchain & compilers:
Hedera supports EVM-compatible smart contracts through the Hedera EVM. However, developers may need to use the Hedera Web3 SDK and adjust configurations to work with Hedera's network.
Hedera EVM Docs
• Fee payment:
Fees are paid in HBAR, Hedera's native token. Additionally, many DeFi applications on Hedera rely on the Hedera Token Service (HTS) for token issuance and transfers instead of standard ERC20 tokens. This means that a standard ERC20 OFT may not work as expected on Hedera.
• On-chain reads:
Not available.
• Further documentation:
Hedera EVM Documentation | Hedera Token Service OverviewTron: EVM Compatible​
Tron is a blockchain platform focused on decentralizing the internet and digital entertainment, utilizing its native TRX token and offering an EVM-compatible environment through its Tron Virtual Machine (TVM).
Key details for LayerZero:• Toolchain & compilers:
Tron supports an EVM-like environment (via Tron Virtual Machine, TVM), but many projects rely on Tron-specific libraries such as TronWeb. While you can deploy standard Solidity contracts, some adaptations may be needed to interface with Tron's unique APIs.
Tron Developer Hub
• Fee payment:
Fees are paid in TRX, Tron's native token. The Tron ecosystem uses standards such as TRC20 (similar to ERC20) for token contracts, so LayerZero integrations that rely on ERC20 conventions generally translate well.
• On-chain reads:
Not available.
• Further documentation:
Tron Developer DocumentationConclusion​
EVM Equivalent chains generally allow you to deploy and operate with minimal changes. However, be sure to account for subtle differences that may impact your contract's logic (e.g., different behaviour in block.number or block.timestamp).
EVM Compatible chains may require adjustments in deployment, fee handling, and gas estimation.
Developer checklist:• Network configuration: Update your deployment scripts with the correct RPC endpoints, chain IDs, and native token details.
• Fee handling: Verify that your payable functions deliver fees in the correct native token as required by the chain.
• Gas estimation: Test gas limits on your target chain to ensure that calls execute successfully.
• On-chain data: Validate that your logic correctly executes as expected, accounting for any drift or inconsistencies.
• Toolchain adjustments: Use chain-specific SDKs or compilers as needed (e.g., zkSync's Hardhat plugin) to guarantee compatibility.By understanding these nuances and consulting the chain-specific documentation linked above, you can adapt your LayerZero cross-chain messaging and token integrations to work reliably across all supported networks.

---
Note: This content was extracted from the LayerZero documentation. Tables and special components have been converted to plain text for better readability.
