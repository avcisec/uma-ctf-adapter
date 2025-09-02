// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;





// LayerZero kütüphaneleri import edilir
// prepareCondition fonksiyonun icerisindeki veri layerZero _lzSend ile gönderilir
// reportPayouts fonksiyonun icerisindeki veri layerZero _lzSend ile gönderilir


contract LayerZeroRelayer {

    //// @dev This function prepares a condition by initializing a payout vector associated with the condition.
    //// @param oracle The account assigned to report the result for the prepared condition.
    //// @param questionId An identifier for the question to be answered by the oracle.
    //// @param outcomeSlotCount The number of outcome slots which should be used for this condition. Must not exceed 256.

    function prepareCondition(address sender, bytes32 questionID, uint256 timeout) external {

    }


    /// @dev Called by the oracle for reporting results of conditions. Will set the payout vector for the condition with the ID ``keccak256(abi.encodePacked(oracle, questionId, outcomeSlotCount))``, where oracle is the message sender, questionId is one of the parameters of this function, and outcomeSlotCount is the length of the payouts parameter, which contains the payoutNumerators for each outcome slot of the condition.
    /// @param questionId The question ID the oracle is answering for
    /// @param payouts The oracle's answer

    function reportPayouts(bytes32 questionId, uint256[] calldata payouts) external {

    }
}