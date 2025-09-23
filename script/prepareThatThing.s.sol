// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {HypiqUmaCtfAdapter} from "src/HypiqUmaCtfAdapter.sol";
import { AncillaryDataLib } from "src/libraries/AncillaryDataLib.sol";
import { IERC20 } from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
contract prepareQuestion is Script {

        address adapter = vm.envAddress("UMA_ADAPTER");
        uint256 rewardAmount = vm.envUint("REWARD_AMOUNT");
        uint256 deployerPrivateKey = vm.envUint("PK");
        address admin = vm.envAddress("ADMIN");
        bytes public  ancillaryData;
        bytes public appendedAncillaryData;
        bytes32 public questionID;
        string question = vm.envString("QUESTION");
        address rewardToken = vm.envAddress("UMA_REWARD_TOKEN");

    /// @notice Yardımcı: string'i bytes'e dönüştürür
    function _stringToBytes(string memory _str) internal pure returns (bytes memory) {
        return bytes(_str);
    }

    function run() external returns (bytes memory){

        vm.startBroadcast(deployerPrivateKey);

        bytes memory ancillaryData = _stringToBytes(question);

        appendedAncillaryData = AncillaryDataLib._appendAncillaryData(admin, ancillaryData);

        questionID = keccak256(appendedAncillaryData);
        IERC20(rewardToken).approve(adapter,rewardAmount);
        vm.stopBroadcast();

       return appendedAncillaryData;

        
    }
}