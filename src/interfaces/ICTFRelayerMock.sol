// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;



interface ICTFRelayerMock {

/*=========================================*\
 |                Events                  |
\*=========================================*/

    /// @dev Emitted when the destination address is set
    event DstAddressSet(address indexed dstAddress);

    /// @dev Emitted when the origin address is set
    event OriginAddressSet(address indexed originAddress);

    /// @dev Emitted when the prepareCondition is sent
    event PrepareConditionSent(address indexed dstAddress, bytes32 indexed questionId, uint256 indexed outcomeSlotCount);

    /// @dev Emitted when the ConditionalTokens contract address is set
    event CtfAddressSet(address indexed ctf);

    /// @dev Emitted when the reportPayouts is sent
    event ReportPayoutsSent(address indexed dstAddress, bytes32 indexed questionId, uint256[] indexed payouts);

    event MessageReceived(address indexed sender,string indexed action);
/*=========================================*\
 |          Interface Functions             |
\*=========================================*/


function prepareCondition(bytes32 _questionId, uint _outcomeSlotCount, bytes calldata _options) external payable;
function reportPayouts(bytes32 _questionId, uint[] calldata _payouts, bytes calldata _options) external payable;
function getPrepareConditionFee(bytes32 _questionId, uint _outcomeSlotCount, bytes calldata _options, bool _payInLzToken) external view returns (uint256 nativeFee);
function getReportPayoutsFee(bytes32 _questionId, uint[] calldata _payouts, bytes calldata _options, bool _payInLzToken) external view returns (uint256 nativeFee);
function _lzReceive(bytes calldata _message, address _executor, bytes calldata _extraData) external;
function setCtfAddress(address _ctf) external;
function setDstAddress(address _dstAddress) external;
/*=========================================*\
 |                 Errors                   |
\*=========================================*/

    error ConditionNotPrepared();


}