// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {HypiqUmaCtfAdapter} from "src/HypiqUmaCtfAdapter.sol";
import { AncillaryDataLib } from "src/libraries/AncillaryDataLib.sol";
contract prepareQuestion is Script {

    HypiqUmaCtfAdapter adapter;

        uint256 deployerPrivateKey = vm.envUint("PK");
        address admin = vm.envAddress("ADMIN");
// Bytes of 'q: title: Will it rain in NYC on Wednesday, description: Will it rain in NYC on Wednesday'
    bytes public constant ancillaryData =
        hex"57696c6c2074686973207465737420776f726b3f";
    bytes public appendedAncillaryData = AncillaryDataLib._appendAncillaryData(admin, ancillaryData);
    bytes32 public questionID = keccak256(appendedAncillaryData);


    function run() external returns (bytes memory){


       return appendedAncillaryData;

        
    }


}