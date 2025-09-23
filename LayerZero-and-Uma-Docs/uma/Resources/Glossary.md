# Glossary

#### Optimistic Oracle

The "Optimistic Oracle" (OO) allows contracts to quickly request and receive price information. Unlike mechanically restrictive price feed oracles, an optimistic oracle can serve any arbitrary data on-chain.

#### DVM <a href="#dvm" id="dvm"></a>

The “Data Verification Mechanism” (DVM) is the name of the oracle service provided by UMA. The DVM does not provide an on-chain price feed. Instead, it is only used to resolve disputes of liquidations and to settle synthetic token contracts upon expiration.

### Parameters of a Long Short Pair (LSP) smart contract: <a href="#parameters-of-a-long-short-pair-lsp-smart-contract" id="parameters-of-a-long-short-pair-lsp-smart-contract"></a>

#### Financial Product Library (FPL) <a href="#financial-product-library-fpl" id="financial-product-library-fpl"></a>

The financial product libraries are used to transform the value returned by the price identifier into a final settlement value. Financial product libraries can be applied to create different types of financial contracts and payout functions.

Refer to [github](https://github.com/UMAprotocol/protocol/tree/master/packages/core/networks) for a list of deployed financial product libraries for each network. If your desired financial product library is not already deployed, refer [here](https://github.com/UMAprotocol/launch-emp#deploying-financial-product-libraries) for instructions on deploying and verifying your own financial product library contract.

#### collateralPerPair <a href="#collateralperpair" id="collateralperpair"></a>

The collateralPerPair parameter determines the amount of collateral required to mint each pair of long and short tokens.

* Example: If a contract uses WETH as collateral and the collateralPerPair parameter is set to 0.25 on deployment, each long and short token that is minted would require 0.25 WETH as collateral.

#### expiryPercentLong <a href="#expirypercentlong" id="expirypercentlong"></a>

ExpiryPercentLong is used to determine the redemption rate between long and short tokens. ExpiryPercentLong is a number between 0 and 1, where 0 assigns all collateral to the short tokens and 1 assigns all collateral to the long tokens.

### UMA Product Types: <a href="#uma-product-types" id="uma-product-types"></a>

#### Range Tokens <a href="#range-tokens" id="range-tokens"></a>

Range tokens enable a DAO to use its native token as collateral to borrow funds. At maturity, if the debt is not paid, the range token holder is instead compensated with an amount of the collateral (the native token) using the settlement price of the native token to determine the number of tokens. This is similar to a tokenized convertible debt structure.

#### Success Tokens <a href="#success-tokens" id="success-tokens"></a>

Success tokens offer an alternative way for DAOs to diversify their treasury and sell tokens to investors in an incentive-aligned way. Success tokens are two financial products wrapped into one token: a set amount of a project token which is combined with a covered call option on that token backed by a set amount of the same token.

#### KPI Options <a href="#kpi-options" id="kpi-options"></a>

Key Performance Indicator (KPI) Options are synthetic tokens that will pay out more rewards if a project’s KPI reaches predetermined targets before a given expiry date. Every KPI Option holder has an incentive to improve that KPI because their option will be worth more. This is intended to align individual token holder interests with the collective interests of the protocol.