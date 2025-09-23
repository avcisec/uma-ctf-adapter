# Mainnet Voting Entities

### Entities

* [`User`](#user)
* [`Collateral`](#collateral)
* [`PriceIdentifier`](#priceidentifier)
* [`PriceRequest`](#pricerequest)
* [`PriceRequestRound`](#pricerequestround)
* [`VoterGroup`](#votergroup)
* [`CommittedVote`](#committedvote)
* [`RevealedVote`](#revealedvote)
* [`RewardsClaimed`](#rewardsclaimed)
* [`FinancialContract`](#financialcontract)

### User

Description:

| Field           | Type   | Description                                                                                                                                       |
| --------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| id              | ID!    | Utility entity that links data from a single Ethereum address. Id of the entity is the Ethereum address itself                                    |
| address         | Bytes! |                                                                                                                                                   |
| countReveals    | BigInt | Number of price requests that this user has revealed a vote for, and therefore participated in as a voter                                         |
| countRetrievals | BigInt | Provides a lower bound on the number of votes a user has correctly voted for. Users may not have retrieved rewards for all of their correct votes |
| votesCommited   | Int!   |                                                                                                                                                   |

### Collateral

Description:

| Field         | Type       | Description                                                                                                                                     |
| ------------- | ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| id            | ID!        | Represents approved collateral that is whitelisted in the AddressWhitelist and whose fees are set in the Store. Id of the entity is its address |
| decimals      | Int!       |                                                                                                                                                 |
| name          | String!    |                                                                                                                                                 |
| symbol        | String!    |                                                                                                                                                 |
| isOnWhitelist | Boolean!   | Is token currently whitelisted as collateral                                                                                                    |
| finalFee      | BigDecimal |                                                                                                                                                 |

### PriceIdentifier

Description:

| Field         | Type                             | Description                                                                                                                                                    |
| ------------- | -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| id            | ID!                              |                                                                                                                                                                |
| isSupported   | Boolean!                         | Depicts whether this PriceIdentifier is currently among the identifiers supported on the whitelist. It will only be false if it was removed from the whitelist |
| priceRequests | [`PriceRequest!`](#pricerequest) | List of all the PriceRequest entities related to this particular PriceIdentifier                                                                               |

### PriceRequest

Description:

| Field                 | Type                                       | Description                                                        |
| --------------------- | ------------------------------------------ | ------------------------------------------------------------------ |
| id                    | ID!                                        | ID is the PriceIdentifier ID + the timestamp                       |
| isResolved            | Boolean!                                   | Depicts whether the request has been resolved                      |
| price                 | BigInt                                     | Price resolved for this request                                    |
| latestRound           | PriceRequestRound                          | PriceRequestRound entity corresponding to the last round of voting |
| time                  | BigInt!                                    |                                                                    |
| identifier            | PriceIdentifier!                           | PriceIdentifier for the request                                    |
| ancillaryData         | String                                     |                                                                    |
| resolutionTransaction | Bytes                                      | Transaction where the resolution of the request took place         |
| resolutionTimestamp   | Bigint                                     | Timestamp when the resolution of the request took place            |
| resolutionBlock       | BigInt                                     | Block number when the resolution of the request took place         |
| rounds                | [`PriceRequestRound!`](#pricerequestround) | List of all the rounds involved in this PriceRequest               |
| committedVotes        | [`CommittedVote!`](#committedvote)         | List of all the votes committed on this request                    |
| revealedVotes         | [`RevealedVote!`](#revealedvote)           | List of all the votes revealed on this request                     |
| rewardsClaimed        | [`RewardsClaimed!`](#rewardsclaimed)       | List of all the rewards claimed events for this request            |

### PriceRequestRound

Description:

| Field                              | Type                                 | Description                                                                               |
| ---------------------------------- | ------------------------------------ | ----------------------------------------------------------------------------------------- |
| id                                 | ID!                                  | ID is the PriceIdentifier ID + the timestamp + the roundId + ancillaryData (if available) |
| request                            | PriceRequest!                        |                                                                                           |
| identifier                         | PriceIdentifier!                     |                                                                                           |
| ancillaryData                      | String                               |                                                                                           |
| time                               | BigInt!                              |                                                                                           |
| snapshotId                         | BigInt                               |                                                                                           |
| votersAmount                       | BigDecimal!                          | Total amount of users who voted on this round                                             |
| votersClaimedAmount                | BigDecimal!                          | Total amount of users who claimed rewards on this round                                   |
| totalVotesRevealed                 | BigDecimal!                          |                                                                                           |
| totaRewardsClaimed                 | BigDecimal!                          |                                                                                           |
| totalSupplyAtSnapshot              | BigDecimal                           |                                                                                           |
| tokenVoteParticipationRatio        | BigDecimal                           | Ratio of the total supply of tokens that were weighted on this vote                       |
| tokenVoteParticipationPercentage   | BigDecimal                           | Ratio of correct voters over total voters on this price request                           |
| votersEligibleForRewardRatio       | BigDecimal                           | Ratio of correct voters over total voters on this price request                           |
| votersEligibleForRewardsPercentage | BigDecimal                           | Percentage of correct voters over total voters on this price request                      |
| votersClaimRatio                   | BigDecimal                           | Ratio of correct voters who claimed their rewards                                         |
| votersClaimedPercentage            | BigDecimal                           | Percentage of correct voters who claimed their rewards                                    |
| tokensClaimedRatio                 | BigDecimal                           | Ratio of rewards claimed over total supply of voting token                                |
| tokensClaimedPercentage            | BigDecimal                           | Percentage of rewards claimed over total supply of voting token                           |
| getPercentageRaw                   | BigDecimal                           | getPercentage expressed exactly as in the contract. 1 = 100%                              |
| getPercentage                      | BigDecimal                           | getPercentage expressed as a percentage value                                             |
| inflationRateRaw                   | BigDecimal                           | inflationRate expressed exactly as in the contract. 1 = 100%                              |
| inflationRate                      | BigDecimal                           | inflationRate expressed as a percentage value                                             |
| winnerGroup                        | VoterGroup                           |                                                                                           |
| committedVotes                     | [`CommittedVote!`](#committedvote)   |                                                                                           |
| revealedVotes                      | [`RevealedVote!`](#revealedvote)     |                                                                                           |
| groups                             | [`VoterGroup!`](#votergroup)         |                                                                                           |
| rewardsClaimed                     | [`RewardsClaimed!`](#rewardsclaimed) |                                                                                           |

### VoterGroup

Description:

| Field           | Type                             | Description                                                                                                    |
| --------------- | -------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| id              | ID!                              | Just a helper entity to group voters who voted the same price result. ID is composed of round ID + voted price |
| price           | BigInt!                          |                                                                                                                |
| round           | PriceRequestRound!               |                                                                                                                |
| votes           | [`RevealedVote!`](#revealedvote) |                                                                                                                |
| totalVoteAmount | BigDecimal!                      |                                                                                                                |
| totalVoteAmount | BigInt                           |                                                                                                                |
| votersAmount    | BigDecimal!                      |                                                                                                                |
| won             | Boolean!                         |                                                                                                                |

### CommittedVote

Description:

| Field         | Type               | Description                                                                               |
| ------------- | ------------------ | ----------------------------------------------------------------------------------------- |
| id            | ID!                | Committed votes won't show the price until a reveal happens and a RevealedVote is created |
| identifier    | PriceIdentifier!   |                                                                                           |
| ancillaryData | String             |                                                                                           |
| request       | PriceRequest!      |                                                                                           |
| time          | BigInt!            |                                                                                           |
| round         | PriceRequestRound! |                                                                                           |
| voter         | User!              |                                                                                           |

### RevealedVote

Description:

| Field         | Type               | Description |
| ------------- | ------------------ | ----------- |
| id            | ID!                |             |
| identifier    | PriceIdentifier!   |             |
| ancillaryData | String             |             |
| request       | PriceRequest!      |             |
| time          | BigInt!            |             |
| round         | PriceRequestRound! |             |
| price         | BigInt!            |             |
| voter         | User!              |             |
| numTokens     | BigInt!            |             |
| group         | VoterGroup!        |             |

### RewardsClaimed

Description:

| Field         | Type               | Description                                                                                                                                         |
| ------------- | ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| id            | ID!                |                                                                                                                                                     |
| identifier    | PriceIdentifier!   |                                                                                                                                                     |
| ancillaryData | String             |                                                                                                                                                     |
| request       | PriceRequest!      |                                                                                                                                                     |
| time          | BigInt!            |                                                                                                                                                     |
| round         | PriceRequestRound! |                                                                                                                                                     |
| claimer       | User!              |                                                                                                                                                     |
| numTokens     | BigInt!            | NumTokens will be 0 if the claim is not 'valid'. This can happen if the function was called for a voter who didn't get the correct vote for example |
| group         | VoterGroup!        |                                                                                                                                                     |

### FinancialContract

Description:

| Field                 | Type    | Description                                                                                                  |
| --------------------- | ------- | ------------------------------------------------------------------------------------------------------------ |
| id                    | ID!     | This entity represents a contract that can make price requests to the DVM. ID is the address of the contract |
| creator               | Bytes!  |                                                                                                              |
| registrationTimestamp | BigInt! |                                                                                                              |