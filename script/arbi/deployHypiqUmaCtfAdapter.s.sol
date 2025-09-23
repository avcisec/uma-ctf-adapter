// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {HypiqUmaCtfAdapter} from "src/HypiqUmaCtfAdapter.sol";

contract deployHypiqUmaCtfAdapter is Script {

    HypiqUmaCtfAdapter adapter;

        uint256 deployerPrivateKey = vm.envUint("PK");
        address ctfRelayerOnBase = vm.envAddress("CTFRELAYER_BASE");
        address finder = vm.envAddress("FINDER");


    function run() external returns (HypiqUmaCtfAdapter) {

        vm.startBroadcast(deployerPrivateKey);

        adapter = new HypiqUmaCtfAdapter(finder,ctfRelayerOnBase);

        vm.stopBroadcast();

        return adapter;
        
    }


}