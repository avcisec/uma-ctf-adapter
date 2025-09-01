// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import { IERC20 } from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import { Auth } from "uma-ctf-adapter/mixins/Auth.sol";
import { BulletinBoard } from "uma-ctf-adapter/mixins/BulletinBoard.sol";

import { TransferHelper } from "uma-ctf-adapter/libraries/TransferHelper.sol";
import { PayoutHelperLib } from "uma-ctf-adapter/libraries/PayoutHelperLib.sol";
import { AncillaryDataLib } from "uma-ctf-adapter/libraries/AncillaryDataLib.sol";

import { IFinder } from "uma-ctf-adapter/interfaces/IFinder.sol";
import { IAddressWhitelist } from "uma-ctf-adapter/interfaces/IAddressWhitelist.sol";
import { IConditionalTokens } from "uma-ctf-adapter/interfaces/IConditionalTokens.sol";
import { IOptimisticOracleV2 } from "uma-ctf-adapter/interfaces/IOptimisticOracleV2.sol";
import { IOptimisticRequester } from "uma-ctf-adapter/interfaces/IOptimisticRequester.sol";

import { QuestionData, IUmaCtfAdapter } from "uma-ctf-adapter/interfaces/IUmaCtfAdapter.sol";

/* BASE CHAIN */
// This contract will be deployed on the Base chain
// LayerZero libraries are imported
// when the question is initialized, the ct.prepareCondition() function is replaced with this information sent by layerZero _lzSend

/* HYPER CHAIN */

// LayerZero _lzReceive function is used to parse the information sent by layerZero and call the ct.prepareCondition() function


/* NOTES */
/* Conditional Tokens in the contract, msg.sender is the address of the uma-ctf-adapter. 
This address will be the address of the contract deployed on the Hyper chain.
USDC is not available on hyperEVM. USDT will be used.
0xB8CE59FC3717ada4C02eaDF9682A9e934F625ebb is the address of the USDT token on the Hyper chain.


*/

/// @title Hypiq Uma Ctf Adapter
/// @notice Uma Ctf Adapter implementation for Hypiq
/// @author 0xBlockBamba

contract HypiqUmaCtfAdapter {
 constructor(address _ctf, address _finder) {
 }
}