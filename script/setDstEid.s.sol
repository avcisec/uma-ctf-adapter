// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {HypiqUmaCtfAdapter} from "src/HypiqUmaCtfAdapter.sol";

contract setDstEid is Script {

        uint256 deployerPrivateKey = vm.envUint("PK");

        function run() external {
            address adapter = vm.envAddress("UMA_ADAPTER");
            uint32 dstEid = uint32(vm.envUint("DST_EID_FOR_HYPERLIQUID_TESTNET"));

            vm.startBroadcast(deployerPrivateKey);

            HypiqUmaCtfAdapter(adapter).setDstEid(dstEid);

            vm.stopBroadcast();
        }


}