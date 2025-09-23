# Disputing Oracle Data

1. Go to the [Optimistic Oracle dApp](https://oracle.umaproject.org/), if you are disputing proposals on a live network like Ethereum, Optimism, or Polygon, or go to the [Testnet dApp](https://testnet.oracle.umaproject.org/) if you are disputing test data on Görli. Disputes will be resolved by the [DVM](https://docs.umaproject.org/protocol-overview/how-does-umas-oracle-work) if you are on a live network, or by a mock oracle if you are on Görli (see Resolving Disputes).
2. Locate proposals under the Proposals tab for outstanding proposals that are within the challenge window and can be disputed.
3. Click on the proposal you want to dispute.
4. Click the 'Connect wallet' button in the top right corner and go through the steps to connect your wallet. Confirm you are on the same network as the proposal.
5. Before disputing, confirm the details of the request and ancillary data to ensure the proposal is actually incorrect. You may also want to check the instructions in the [UMIP](https://docs.umaproject.org/resources/approved-price-identifiers) for the identifier.
6. Click the 'Dispute Proposal' button.
7. Confirm the transaction details through your wallet provider. After confirming, the proposal will be disputed.
8. If you are on a live network, the dispute will escalate to the DVM on Ethereum for resolution. If you are on Görli, you will need to manually resolve the dispute through the [Mock Oracle](https://goerli.etherscan.io/address/0x20570e9e27920ac5e2601e0bef7244deff7f0b28#code).