# Unsupported Contracts

Risk Labs/UMA protocol no longer actively supports or improves:

* The [Expiring Multi-Party (EMP)](https://github.com/UMAprotocol/launch-emp)
* The[ Perpetual Multi-Party](https://github.com/UMAprotocol/protocol/tree/master/packages/core/contracts/financial-templates/perpetual-multiparty)

These contracts are open-source code, and anyone is free to use, improve, or fork the code. However note that for these contracts to be safe, it requires a robust system of well capitalized off-chain watchers (liquidator & disputer bots) to continually check that positions are appropriately collateralized, or that positions are not being liquidated unfairly. Anyone using this code in production must ensure that there are well-capitalized liquidators and disputers running at all times; failure to do so could result in a loss of all locked funds. Risk Labs does not and will not run liquidators for these contracts, nor does it give any security assurances about any EMP or Perp contracts.\
\
As always, UMA protocol and Risk Labs will continue to support proposed addition or request of price identifiers for general use including within EMP/Perp contracts.