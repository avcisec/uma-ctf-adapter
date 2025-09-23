# Solidity API

URL: https://docs.layerzero.network/v2/developers/evm/technical-reference/api

Version: Endpoint V2Solidity APIEndpointV2​
lzToken​```
address lzToken
```This stores the address of the LayerZero token, which may be used for paying messaging fees. It enables applications to settle cross-chain communication costs using LayerZero's native token, where applicable.
delegates​```
mapping(address => address) delegates
```A mapping that allows address-based delegation. Applications (OApps) can delegate certain privileges to another address, authorizing the delegate to perform tasks on behalf of the original sender.
constructor​```
constructor(uint32 _eid, address _owner) public
```The constructor initializes the LayerZero endpoint on a specific chain. It assigns a unique Endpoint ID (_eid) to this instance, ensuring each chain has a distinct identifier for cross-chain messaging.
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_eid | uint32 | the unique Endpoint Id for this deploy that all other Endpoints can use to send to it
_owner | address |
--- End Table ---quote​```
function quote(struct MessagingParams _params, address _sender) external view returns (struct MessagingFee)
```This function returns a fee estimate for sending a cross-chain message, based on the parameters specified in _params. The fee quote takes into account the current messaging cost, which might vary over time. Note that the actual messaging cost could differ if the fees change between the quote and the message send operation.
MESSAGING STEP 0
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_params | struct MessagingParams | the messaging parameters
_sender | address | the sender of the message
--- End Table ---send​```
function send(struct MessagingParams _params, address _refundAddress) external payable returns (struct MessagingReceipt)
```This function sends a message to a destination chain through the LayerZero network. It also processes the associated fees, which can be either in native tokens or LayerZero tokens (lzToken). If excess fees are supplied, the surplus is refunded to the provided _refundAddress.
MESSAGING STEP 1 - OApp need to transfer the fees to the endpoint before sending the message
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_params | struct MessagingParams | the messaging parameters
_refundAddress | address | the address to refund both the native and lzToken
--- End Table ---_send​```
function _send(address _sender, struct MessagingParams _params) internal returns (struct MessagingReceipt, address)
```An internal version of the send function that handles the underlying mechanics of sending a message. This function is called by external message-sending methods and ensures the message is routed to the appropriate destination with the correct fee management.
internal function for sending the messages used by all external send methods
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_sender | address | the address of the application sending the message to the destination chain
_params | struct MessagingParams | the messaging parameters
--- End Table ---verify​```
function verify(struct Origin _origin, address _receiver, bytes32 _payloadHash) external
```On the destination chain, the message needs to be verified before being processed. This function checks the validity of the incoming message by comparing its origin and payload hash with the expected values.
MESSAGING STEP 2 - on the destination chain
configured receive library verifies a message
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_origin | struct Origin | a struct holding the srcEid, nonce, and sender of the message
_receiver | address | the receiver of the message
_payloadHash | bytes32 | the payload hash of the message
--- End Table ---lzReceive​```
function lzReceive(struct Origin _origin, address _receiver, bytes32 _guid, bytes _message, bytes _extraData) external payable
```This is the final step in the message execution process. After the message has been verified, it is delivered to the intended recipient address. The function can pass additional extraData if needed for execution.
MESSAGING STEP 3 - the last step
execute a verified message to the designated receiver
the execution provides the execution context (caller, extraData) to the receiver. the receiver can optionally assert the caller and validate the untrusted extraData
cant reentrant because the payload is cleared before execution
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_origin | struct Origin | the origin of the message
_receiver | address | the receiver of the message
_guid | bytes32 | the guid of the message
_message | bytes | the message
_extraData | bytes | the extra data provided by the executor. this data is untrusted and should be validated.
--- End Table ---lzReceiveAlert​```
function lzReceiveAlert(struct Origin _origin, address _receiver, bytes32 _guid, uint256 _gas, uint256 _value, bytes _message, bytes _extraData, bytes _reason) external
```This function handles a failure in message delivery and provides an alert to the application. It logs the reason for the failure and the state of the message, allowing developers to debug message processing errors.
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_origin | struct Origin | the origin of the message
_receiver | address | the receiver of the message
_guid | bytes32 | the guid of the message
_gas | uint256 |
_value | uint256 |
_message | bytes | the message
_extraData | bytes | the extra data provided by the executor.
_reason | bytes | the reason for failure
--- End Table ---clear​```
function clear(address _oapp, struct Origin _origin, bytes32 _guid, bytes _message) external
```This function allows an OApp (Omnichain Application) to clear a pending message manually. Instead of pushing the message through the standard delivery flow, the message is cleared from the queue, effectively marking it as processed or ignored.
_Oapp uses this interface to clear a message.
this is a PULL mode versus the PUSH mode of lzReceive
the cleared message can be ignored by the app (effectively burnt)
authenticated by oapp_
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_oapp | address |
_origin | struct Origin | the origin of the message
_guid | bytes32 | the guid of the message
_message | bytes | the message
--- End Table ---setLzToken​```
function setLzToken(address _lzToken) public virtual
```This function allows the owner to set or change the LayerZero token (lzToken). This token may be used to pay for messaging fees. The function is designed to provide flexibility in case the initial configuration of the token was incorrect or needs to be updated. It should only be called by the contract owner.
Users should avoid approving non-LayerZero tokens to be spent by the EndpointV2 contract, as this function can override the token used for fees.
allows reconfiguration to recover from wrong configurations
users should never approve the EndpointV2 contract to spend their non-layerzero tokens
override this function if the endpoint is charging ERC20 tokens as native
only owner
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_lzToken | address | the new layer zero token address
--- End Table ---recoverToken​```
function recoverToken(address _token, address _to, uint256 _amount) external
```This function allows the owner to recover tokens that were mistakenly sent to the EndpointV2 contract. It supports both native tokens (if _token is set to 0x0) and ERC20 tokens. This ensures that tokens accidentally locked in the contract can be safely retrieved by the owner.
recover the token sent to this contract by mistake
only owner
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_token | address | the token to recover. if 0x0 then it is native token
_to | address | the address to send the token to
_amount | uint256 | the amount to send
--- End Table ---_payToken​```
function _payToken(address _token, uint256 _required, uint256 _supplied, address _receiver, address _refundAddress) internal
```This internal function handles payments in ERC20 tokens. It ensures that the sender has approved the endpoint to spend the specified tokens and processes the payment. If the supplied token amount exceeds the required amount, the excess is refunded to the specified _refundAddress.
handling token payments on endpoint. the sender must approve the endpoint to spend the token
internal function
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_token | address | the token to pay
_required | uint256 | the amount required
_supplied | uint256 | the amount supplied
_receiver | address | the receiver of the token
_refundAddress | address |
--- End Table ---_payNative​```
function _payNative(uint256 _required, uint256 _supplied, address _receiver, address _refundAddress) internal virtual
```This internal function manages payments in native tokens (such as ETH). It processes the payment and refunds any excess amount to the _refundAddress. If the endpoint charges ERC20 tokens as native, this function can be overridden.
handling native token payments on endpoint
override this if the endpoint is charging ERC20 tokens as native
internal function
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_required | uint256 | the amount required
_supplied | uint256 | the amount supplied
_receiver | address | the receiver of the native token
_refundAddress | address | the address to refund the excess to
--- End Table ---_suppliedLzToken​```
function _suppliedLzToken(bool _payInLzToken) internal view returns (uint256 supplied)
```This internal view function returns the amount of LayerZero tokens (lzToken) supplied for payment, but only if _payInLzToken is set to true. It checks the balance of the lzToken used to pay for the messaging fee.
get the balance of the lzToken as the supplied lzToken fee if payInLzToken is true
_suppliedNative​```
function _suppliedNative() internal view virtual returns (uint256)
```This internal function returns the amount of native tokens supplied for the payment. If the endpoint charges ERC20 tokens as native tokens, this function can be overridden to handle such cases.
override this if the endpoint is charging ERC20 tokens as native
_assertMessagingFee​```
function _assertMessagingFee(struct MessagingFee _required, uint256 _suppliedNativeFee, uint256 _suppliedLzTokenFee) internal pure
```This internal function verifies that the supplied fees (both native and lzToken) are sufficient to cover the required messaging fees. If the supplied fees are insufficient, the function will assert an error.
Assert the required fees and the supplied fees are enough
nativeToken​```
function nativeToken() external view virtual returns (address)
```This external view function returns the address of the native ERC20 token used by the endpoint if it charges ERC20 tokens as native tokens. If the contract uses actual native tokens (like ETH), it returns 0x0.
override this if the endpoint is charging ERC20 tokens as native
Return Values​--- Table ---
Name | Type | Description
--- | --- | ---
[0] | address | 0x0 if using native. otherwise the address of the native ERC20 token
--- End Table ---setDelegate​```
function setDelegate(address _delegate) external
```This function allows an OApp to authorize a delegate to act on its behalf. The delegate can configure settings or perform other operations related to the LayerZero endpoint, effectively giving another address certain administrative permissions over the OApp's endpoint interaction.
delegate is authorized by the oapp to configure anything in layerzero
_initializable​```
function _initializable(struct Origin _origin, address _receiver, uint64 _lazyInboundNonce) internal view returns (bool)
```This internal view function checks whether a message from a specific origin can be initialized for delivery to the receiver. The function verifies that the message can be safely processed based on the lazyInboundNonce, which controls the message order and flow.
_verifiable​```
function _verifiable(struct Origin _origin, address _receiver, uint64 _lazyInboundNonce) internal view returns (bool)
```This internal function checks whether a message from the given origin is verifiable for the receiver. It ensures that the message payload is valid and ready for execution based on the provided nonce and other checks.
A payload with a hash of bytes(0) can never be submitted.
bytes(0) payloadHash can never be submitted
_assertAuthorized​```
function _assertAuthorized(address _oapp) internal view
```This internal function ensures that the caller is either the OApp or its authorized delegate. It acts as an access control check to verify that only trusted entities can configure or interact with the OApp's LayerZero-related settings.
assert the caller to either be the oapp or the delegate
initializable​```
function initializable(struct Origin _origin, address _receiver) external view returns (bool)
```This external view function checks whether a message from the given origin is ready to be initialized and processed for the specified receiver. It returns true if the message can be initialized.
verifiable​```
function verifiable(struct Origin _origin, address _receiver) external view returns (bool)
```This external view function checks whether a message from the given origin is verifiable for the receiver. It confirms that the message payload has been received and validated.
EndpointV2Alt​
EndpointV2Alt is the LayerZero V2 endpoint contract designed for blockchain networks where ERC20 tokens are used as native tokens (instead of standard native tokens like ETH or BNB). This contract supports altFeeTokens, which are ERC20 tokens that can be used for paying messaging fees. The architecture is optimized to reduce gas costs by making certain configurations immutable.
LZ_OnlyAltToken​```
error LZ_OnlyAltToken()
```This error is thrown when a non-ERC20 token is used in a context where only the altFeeToken (an ERC20 token) is allowed. It enforces that only the designated ERC20 token is used for certain operations in the contract.
nativeErc20​```
address nativeErc20
```This holds the address of the ERC20 token used as the native currency in this contract. The nativeErc20 token is immutable, meaning that once it's set, it cannot be changed. This saves gas by preventing unnecessary updates and checks. This token is used for paying fees when the chain doesn't have a standard native token.
the altFeeToken is used for fees when the native token has no value
it is immutable for gas saving. only 1 endpoint for such chains
constructor​```
constructor(uint32 _eid, address _owner, address _altToken) public
```The constructor initializes the EndpointV2Alt contract, associating it with a unique Endpoint ID (_eid). It also specifies the owner of the contract and the altFeeToken (an ERC20 token) used for fees on the chain.
_payNative​```
function _payNative(uint256 _required, uint256 _supplied, address _receiver, address _refundAddress) internal
```This internal function handles native payments in the context of this contract. Since the contract operates on chains using ERC20 tokens as native tokens, _payNative processes payments in those tokens. If the supplied amount exceeds the required amount, the excess is refunded to the _refundAddress.
handling native token payments on endpoint
internal function
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_required | uint256 | the amount required
_supplied | uint256 | the amount supplied
_receiver | address | the receiver of the native token
_refundAddress | address | the address to refund the excess to
--- End Table ---_suppliedNative​```
function _suppliedNative() internal view returns (uint256)
```This internal view function returns the amount of native tokens (ERC20 tokens, in this case) supplied for the payment. It is used to track the exact amount of tokens provided for a transaction, ensuring that the necessary fees are met.
return the balance of the native token
setLzToken​```
function setLzToken(address _lzToken) public
```This function allows the contract owner to set or change the LayerZero token (lzToken). The function checks if the new token address matches the current one before applying changes. The lzToken can be used for paying fees when applicable.
check if lzToken is set to the same address
nativeToken​```
function nativeToken() external view returns (address)
```This external view function returns the address of the native ERC20 token used by the contract. If the contract uses actual native tokens, it returns 0x0. Otherwise, it returns the address of the ERC20 token acting as the native currency on the chain.
override this if the endpoint is charging ERC20 tokens as native
Return Values​--- Table ---
Name | Type | Description
--- | --- | ---
[0] | address | 0x0 if using native. otherwise the address of the native ERC20 token
--- End Table ---EndpointV2View​
EndpointV2View is a contract used for viewing the state of LayerZero V2 messages, particularly related to whether a message is verifiable, executable, or initializable. This contract is typically used by other contracts or off-chain services that need to check the status of cross-chain messages.
initialize​```
function initialize(address _endpoint) external
```The initialize function sets the reference to the LayerZero endpoint (_endpoint). This endpoint is used for all subsequent verifications and message status checks. This function must be called before the contract can be used.
ExecutionState​```
enum ExecutionState {  NotExecutable,  VerifiedButNotExecutable,  Executable,  Executed}
```This enum defines the possible execution states for a message within the LayerZero system:
NotExecutable: The message is not yet ready for execution.
VerifiedButNotExecutable: The message has been verified, but something is preventing its execution (e.g., not enough gas).
Executable: The message is ready to be executed.
Executed: The message has been successfully executed.
EndpointV2ViewUpgradeable​
EndpointV2ViewUpgradeable is an upgradeable version of the EndpointV2View, adding support for certain upgrades while maintaining compatibility with existing state.
EMPTY_PAYLOAD_HASH​```
bytes32 EMPTY_PAYLOAD_HASH
```This constant represents an empty payload hash, which can be used to signal that no payload is associated with a message.
NIL_PAYLOAD_HASH​```
bytes32 NIL_PAYLOAD_HASH
```This constant represents a "nil" payload hash, often used to indicate that a payload has been intentionally left out or invalidated.
endpoint​```
contract ILayerZeroEndpointV2 endpoint
```This contract reference stores the LayerZero endpoint that the EndpointV2ViewUpgradeable is interacting with. It is used for all message-related queries and verifications.
__EndpointV2View_init​```
function __EndpointV2View_init(address _endpoint) internal
```This internal initialization function sets the reference to the LayerZero endpoint. This function must be called during the deployment process to initialize the contract.
__EndpointV2View_init_unchained​```
function __EndpointV2View_init_unchained(address _endpoint) internal
```This is a version of the initialization function that is not chained. It can be used in scenarios where the contract needs to be initialized without triggering additional logic.
initializable​```
function initializable(struct Origin _origin, address _receiver) public view returns (bool)
```This function checks if a message from a specific origin can be initialized for the provided receiver. It returns true if the message is ready to be processed (initialized).
verifiable​```
function verifiable(struct Origin _origin, address _receiver, address _receiveLib, bytes32 _payloadHash) public view returns (bool)
```This function checks if a message from the given origin is verifiable for the provided receiver. It ensures that the payload hash matches and the message has been validated by the correct messaging library.
check if a message is verifiable.
executable​```
function executable(struct Origin _origin, address _receiver) public view returns (enum ExecutionState)
```This function checks the execution state of a message for a given origin and receiver. It returns the current execution state, whether the message is NotExecutable, VerifiedButNotExecutable, Executable, or Executed.
check if a message is executable.
Return Values​--- Table ---
Name | Type | Description
--- | --- | ---
[0] | enum ExecutionState | ExecutionState of Executed, Executable, or NotExecutable
--- End Table ---MessageLibManager​
MessageLibManager manages the messaging libraries (msgLib) that are used for sending and receiving messages in the LayerZero protocol. It controls the libraries that each application (OApp) can use, either by directly assigning libraries or defaulting to LayerZero's settings.
blockedLibrary​```
address blockedLibrary
```The blockedLibrary is a specific library that is no longer allowed for sending or receiving messages.
registeredLibraries​```
address[] registeredLibraries
```An array storing the addresses of all libraries that are registered and can be used for message sending or receiving.
isRegisteredLibrary​```
mapping(address => bool) isRegisteredLibrary
```This mapping tracks whether a given library is registered, providing a quick way to verify if a library is eligible for use.
sendLibrary​```
mapping(address => mapping(uint32 => address)) sendLibrary
```A mapping that stores the send libraries for each OApp (address) and endpoint ID (uint32). Each OApp can specify a library it wants to use for sending messages to a specific endpoint.
receiveLibrary​```
mapping(address => mapping(uint32 => address)) receiveLibrary
```This mapping stores the receive libraries for each OApp (address) and endpoint ID (uint32). Each OApp can specify a library for handling received messages.
receiveLibraryTimeout​```
mapping(address => mapping(uint32 => struct IMessageLibManager.Timeout)) receiveLibraryTimeout
```This mapping tracks the timeout period for a receive library. After a timeout period, the receive library may need to be updated or replaced. This helps manage library versioning and ensure that OApps can handle breaking changes in a safe manner.
defaultSendLibrary​```
mapping(uint32 => address) defaultSendLibrary
```This mapping holds the default send library for each endpoint (uint32). If an OApp does not specify a send library, the default send library for that endpoint is used.
defaultReceiveLibrary​```
mapping(uint32 => address) defaultReceiveLibrary
```The default receive library for each endpoint is stored here. If an OApp does not specify a receive library, the system defaults to the configured library for that endpoint.
defaultReceiveLibraryTimeout​```
mapping(uint32 => struct IMessageLibManager.Timeout) defaultReceiveLibraryTimeout
```This mapping tracks the timeout period for default receive libraries. After this period, the default library may need to be updated or retired.
constructor​```
constructor() internal
```The constructor is internal and initializes the MessageLibManager. It ensures that all the necessary mappings and configurations are properly set up when the contract is deployed.
onlyRegistered​```
modifier onlyRegistered(address _lib)
```This modifier ensures that only libraries registered with MessageLibManager can call certain functions. It restricts access to unregistered libraries, safeguarding the system from misuse.
isSendLib​```
modifier isSendLib(address _lib)
```This modifier ensures that only valid send libraries can call specific functions. It checks if the library is properly configured for sending messages.
isReceiveLib​```
modifier isReceiveLib(address _lib)
```This modifier ensures that only valid receive libraries can call certain functions. It verifies the library's eligibility for processing received messages.
onlyRegisteredOrDefault​```
modifier onlyRegisteredOrDefault(address _lib)
```This modifier allows both registered libraries and default libraries to access certain functions, ensuring that the system works even when custom libraries are not defined.
onlySupportedEid​```
modifier onlySupportedEid(address _lib, uint32 _eid)
```This modifier ensures that a library supports a specific endpoint ID (_eid). It checks if the library has been configured to handle messages for that endpoint.
check if the library supported the eid.
getRegisteredLibraries​```
function getRegisteredLibraries() external view returns (address[])
```This function returns a list of all registered libraries. It allows users and applications to query which libraries are available for use.
getSendLibrary​```
function getSendLibrary(address _sender, uint32 _dstEid) public view returns (address lib)
```This function retrieves the send library for a specific OApp (_sender) and destination endpoint (_dstEid). If the OApp has not specified a library, the default one is used.
If the Oapp does not have a selected Send Library, this function will resolve to the default library
configured by LayerZero
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_sender | address | The address of the Oapp that is sending the message
_dstEid | uint32 | The destination endpoint id
--- End Table ---Return Values​--- Table ---
Name | Type | Description
--- | --- | ---
lib | address | address of the Send Library
--- End Table ---isDefaultSendLibrary​```
function isDefaultSendLibrary(address _sender, uint32 _dstEid) public view returns (bool)
```This function checks if the send library in use for a specific OApp and endpoint is the default one.
getReceiveLibrary​```
function getReceiveLibrary(address _receiver, uint32 _srcEid) public view returns (address lib, bool isDefault)
```This function retrieves the receive library for a specific OApp (_receiver) and source endpoint (_srcEid). If the OApp has not specified a library, the default one is used.
the receiveLibrary can be lazily resolved that if not set it will point to the default configured by LayerZero
isValidReceiveLibrary​```
function isValidReceiveLibrary(address _receiver, uint32 _srcEid, address _actualReceiveLib) public view returns (bool)
```This function checks if the specified receive library is valid for a given OApp, ensuring that the OApp can trust the message verification and processing done by the library.
called when the endpoint checks if the msgLib attempting to verify the msg is the configured msgLib of the Oapp
this check provides the ability for Oapp to lock in a trusted msgLib
it will fist check if the msgLib is the currently configured one. then check if the msgLib is the one in grace period of msgLib versioning upgrade
registerLibrary​```
function registerLibrary(address _lib) public
```This function registers a new library with the MessageLibManager. Only the contract owner can register new libraries.
all libraries have to implement the erc165 interface to prevent wrong configurations
only owner
setDefaultSendLibrary​```
function setDefaultSendLibrary(uint32 _eid, address _newLib) external
```The contract owner sets the default send library for a specific endpoint. The new library must be registered and have support for the endpoint.
owner setting the defaultSendLibrary
can set to the blockedLibrary, which is a registered library
the msgLib must enable the support before they can be registered to the endpoint as the default
only owner
setDefaultReceiveLibrary​```
function setDefaultReceiveLibrary(uint32 _eid, address _newLib, uint256 _gracePeriod) external
```The contract owner sets the default receive library for a specific endpoint and may define a grace period during which the old library can still be used.
owner setting the defaultSendLibrary
must be a registered library (including blockLibrary) with the eid support enabled
in version migration, it can add a grace period to the old library. if the grace period is 0, it will delete the timeout configuration.
only owner
setDefaultReceiveLibraryTimeout​```
function setDefaultReceiveLibraryTimeout(uint32 _eid, address _lib, uint256 _expiry) external
```This function allows the contract owner to set a timeout for the default receive library for a given endpoint. After the timeout, the library may need to be updated or retired.
owner setting the defaultSendLibrary
must be a registered library (including blockLibrary) with the eid support enabled
can used to (1) extend the current configuration (2) force remove the current configuration (3) change to a new configuration
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_eid | uint32 |
_lib | address |
_expiry | uint256 | the block number when lib expires
--- End Table ---isSupportedEid​```
function isSupportedEid(uint32 _eid) external view returns (bool)
```This function checks if an endpoint is supported, returning true only if both the default send and receive libraries are set.
returns true only if both the default send/receive libraries are set
setSendLibrary​```
function setSendLibrary(address _oapp, uint32 _eid, address _newLib) external
```This function allows an OApp to set a custom send library for a specific endpoint. The library must be registered and support the endpoint.
Oapp setting the sendLibrary
must be a registered library (including blockLibrary) with the eid support enabled
authenticated by the Oapp
setReceiveLibrary​```
function setReceiveLibrary(address _oapp, uint32 _eid, address _newLib, uint256 _gracePeriod) external
```An OApp can use this function to set a custom receive library, with an optional grace period during which the old library can still be used.
Oapp setting the receiveLibrary
must be a registered library (including blockLibrary) with the eid support enabled
in version migration, it can add a grace period to the old library. if the grace period is 0, it will delete the timeout configuration.
authenticated by the Oapp
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_oapp | address |
_eid | uint32 |
_newLib | address |
_gracePeriod | uint256 | the number of blocks from now until oldLib expires
--- End Table ---setReceiveLibraryTimeout​```
function setReceiveLibraryTimeout(address _oapp, uint32 _eid, address _lib, uint256 _expiry) external
```This function allows the OApp to set a timeout for its custom receive library. After the timeout, the OApp may need to update the library.
Oapp setting the defaultSendLibrary
must be a registered library (including blockLibrary) with the eid support enabled
can used to (1) extend the current configuration (2) force remove the current configuration (3) change to a new configuration
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_oapp | address |
_eid | uint32 |
_lib | address |
_expiry | uint256 | the block number when lib expires
--- End Table ---setConfig​```
function setConfig(address _oapp, address _lib, struct SetConfigParam[] _params) external
```This function allows the OApp to configure the messaging libraries with specific parameters.
authenticated by the _oapp
getConfig​```
function getConfig(address _oapp, address _lib, uint32 _eid, uint32 _configType) external view returns (bytes config)
```This function retrieves the current configuration of the OApp's messaging libraries for a given endpoint and config type.
a view function to query the current configuration of the OApp
_assertAuthorized​```
function _assertAuthorized(address _oapp) internal virtual
```MessagingChannel​
The MessagingChannel contract manages the lifecycle of messages sent across different blockchains using the LayerZero protocol. It tracks the nonces, payloads, and statuses of messages to ensure censorship resistance and reliable cross-chain communication.
EMPTY_PAYLOAD_HASH​```
bytes32 EMPTY_PAYLOAD_HASH
```A constant representing an empty payload hash. This value is used when a message has no payload associated with it.
NIL_PAYLOAD_HASH​```
bytes32 NIL_PAYLOAD_HASH
```A constant representing a "nil" payload hash, used to indicate that a payload is invalidated or should be ignored.
eid​```
uint32 eid
```The unique Endpoint ID associated with this deployed messaging channel. It ensures that messages are routed correctly across different endpoints in LayerZero.
lazyInboundNonce​```
mapping(address => mapping(uint32 => mapping(bytes32 => uint64))) lazyInboundNonce
```A mapping that tracks the inbound nonces for messages received. The nonces are updated lazily, meaning the nonce is incremented only when messages are processed, ensuring message order is preserved.
inboundPayloadHash​```
mapping(address => mapping(uint32 => mapping(bytes32 => mapping(uint64 => bytes32)))) inboundPayloadHash
```This mapping stores the hash of the payload for inbound messages. Each payload is uniquely identified by its sender, source endpoint, and nonce.
outboundNonce​```
mapping(address => mapping(uint32 => mapping(bytes32 => uint64))) outboundNonce
```This mapping tracks the next outbound nonce for a given sender, destination endpoint, and receiver. Nonces ensure that messages are delivered in order and without duplication.
constructor​```
constructor(uint32 _eid) internal
```The internal constructor initializes the messaging channel with the unique Endpoint ID (_eid). This ID is used to identify the channel in LayerZero's messaging system.
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_eid | uint32 | is the universally unique id (UUID) of this deployed Endpoint
--- End Table ---_outbound​```
function _outbound(address _sender, uint32 _dstEid, bytes32 _receiver) internal returns (uint64 nonce)
```This internal function increments and returns the next outbound nonce for the sender. It ensures that outbound messages are properly sequenced.
increase and return the next outbound nonce
_inbound​```
function _inbound(address _receiver, uint32 _srcEid, bytes32 _sender, uint64 _nonce, bytes32 _payloadHash) internal
```The _inbound function updates the inbound message state lazily. It doesn't immediately increment the nonce, allowing for out-of-order message verification while preserving censorship resistance.
inbound won't update the nonce eagerly to allow unordered verification
instead, it will update the nonce lazily when the message is received
messages can only be cleared in order to preserve censorship-resistance
inboundNonce​```
function inboundNonce(address _receiver, uint32 _srcEid, bytes32 _sender) public view returns (uint64)
```This function returns the highest contiguous verified inbound nonce. It iterates over the nonces, starting from the lazy inbound nonce, to find the last verified message.
returns the max index of the longest gapless sequence of verified msg nonces.
the uninitialized value is 0. the first nonce is always 1
it starts from the lazyInboundNonce (last checkpoint) and iteratively check if the next nonce has been verified
this function can OOG if too many backlogs, but it can be trivially fixed by just clearing some prior messages
NOTE: Oapp explicitly skipped nonces count as "verified" for these purposes
eg. [1,2,3,4,6,7] => 4, [1,2,6,8,10] => 2, [1,3,4,5,6] => 1
_hasPayloadHash​```
function _hasPayloadHash(address _receiver, uint32 _srcEid, bytes32 _sender, uint64 _nonce) internal view returns (bool)
```This function checks if a given payload hash exists for a specific nonce. It assumes that a payload hash of zero means the payload has not been initialized.
checks if the storage slot is not initialized. Assumes computationally infeasible that payload can hash to 0
skip​```
function skip(address _oapp, uint32 _srcEid, bytes32 _sender, uint64 _nonce) external
```The skip function allows an OApp to skip a specific nonce, preventing the message from being verified or executed. This can be useful in race conditions or when a message is flagged as malicious. After skipping, the lazy inbound nonce is updated.
the caller must provide _nonce to prevent skipping the unintended nonce
it could happen in some race conditions, e.g. to skip nonce 3, but nonce 3 was consumed first
usage: skipping the next nonce to prevent message verification, e.g. skip a message when Precrime throws alerts
if the Oapp wants to skip a verified message, it should call the clear() function instead
after skipping, the lazyInboundNonce is set to the provided nonce, which makes the inboundNonce also the provided nonce
ie. allows the Oapp to increment the lazyInboundNonce without having had that corresponding msg be verified
nilify​```
function nilify(address _oapp, uint32 _srcEid, bytes32 _sender, uint64 _nonce, bytes32 _payloadHash) external
```This function marks a verified packet as nil, preventing it from being executed. A nilified packet cannot be verified or executed again unless it is re-verified with the correct payload hash.
Marks a packet as verified, but disallows execution until it is re-verified.
Reverts if the provided _payloadHash does not match the currently verified payload hash.
A non-verified nonce can be nilified by passing EMPTY_PAYLOAD_HASH for _payloadHash.
Assumes the computational intractability of finding a payload that hashes to bytes32.max.
Authenticated by the caller
burn​```
function burn(address _oapp, uint32 _srcEid, bytes32 _sender, uint64 _nonce, bytes32 _payloadHash) external
```The burn function permanently marks a packet as unexecutable and un-verifiable. This action is irreversible and can only be performed on packets that have not yet been executed.
Marks a nonce as unexecutable and un-verifiable. The nonce can never be re-verified or executed.
Reverts if the provided _payloadHash does not match the currently verified payload hash.
Only packets with nonces less than or equal to the lazy inbound nonce can be burned.
Reverts if the nonce has already been executed.
Authenticated by the caller
_clearPayload​```
function _clearPayload(address _receiver, uint32 _srcEid, bytes32 _sender, uint64 _nonce, bytes _payload) internal returns (bytes32 actualHash)
```This function clears the stored payload for a message and updates the lazy inbound nonce. If there are many queued messages, the payload can be cleared in smaller batches to prevent out-of-gas errors.
calling this function will clear the stored message and increment the lazyInboundNonce to the provided nonce
if a lot of messages are queued, the messages can be cleared with a smaller step size to prevent OOG
NOTE: this function does not change inboundNonce, it only changes the lazyInboundNonce up to the provided nonce
nextGuid​```
function nextGuid(address _sender, uint32 _dstEid, bytes32 _receiver) external view returns (bytes32)
```The nextGuid function returns the GUID for the next message in a specific path, providing a unique identifier for the message that can be included in the payload.
returns the GUID for the next message given the path
the Oapp might want to include the GUID into the message in some cases
_assertAuthorized​```
function _assertAuthorized(address _oapp) internal virtual
```This internal function ensures that the caller of specific messaging operations is authorized, either by being the OApp or its delegate.
MessagingComposer​
The MessagingComposer contract is responsible for composing LayerZero messages, enabling applications (OApps) to send messages in smaller piecewise operations or add extra steps to messages.
composeQueue​```
mapping(address => mapping(address => mapping(bytes32 => mapping(uint16 => bytes32)))) composeQueue
```The composeQueue stores composed message fragments for each OApp. It maps the OApp's address, the receiver's address, a message GUID, and an index (for multi-part messages) to the hash of the composed message fragment. This ensures that messages can be composed and sent in a fragmented manner.
sendCompose​```
function sendCompose(address _to, bytes32 _guid, uint16 _index, bytes _message) external
```The sendCompose function allows an OApp to send a composed message fragment to the receiver. The sender must be authenticated, ensuring that only the intended OApp can send the message. Multiple fragments can be sent with the same GUID, allowing for more flexible message composition.
the Oapp sends the lzCompose message to the endpoint
the composer MUST assert the sender because anyone can send compose msg with this function
with the same GUID, the Oapp can send compose to multiple _composer at the same time
authenticated by the msg.sender
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_to | address | the address which will receive the composed message
_guid | bytes32 | the message guid
_index | uint16 |
_message | bytes | the message
--- End Table ---lzCompose​```
function lzCompose(address _from, address _to, bytes32 _guid, uint16 _index, bytes _message, bytes _extraData) external payable
```The lzCompose function executes a composed message from the sender to the receiver. It provides the execution context (caller and extraData) to the receiver, allowing for additional validation.
execute a composed messages from the sender to the composer (receiver)
the execution provides the execution context (caller, extraData) to the receiver.
the receiver can optionally assert the caller and validate the untrusted extraData
can not re-entrant
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_from | address | the address which sends the composed message. in most cases, it is the Oapp's address.
_to | address | the address which receives the composed message
_guid | bytes32 | the message guid
_index | uint16 |
_message | bytes | the message
_extraData | bytes | the extra data provided by the executor. this data is untrusted and should be validated.
--- End Table ---lzComposeAlert​```
function lzComposeAlert(address _from, address _to, bytes32 _guid, uint16 _index, uint256 _gas, uint256 _value, bytes _message, bytes _extraData, bytes _reason) external
```The lzComposeAlert function is triggered when an issue occurs during message composition. It allows the contract to report why a composed message could not be processed.
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_from | address | the address which sends the composed message
_to | address | the address which receives the composed message
_guid | bytes32 | the message guid
_index | uint16 |
_gas | uint256 |
_value | uint256 |
_message | bytes | the message
_extraData | bytes | the extra data provided by the executor
_reason | bytes | the reason why the message is not received
--- End Table ---MessagingContext​
The MessagingContext contract acts as a guard for preventing reentrancy and also provides execution context for messages sent and received in LayerZero.
this contract acts as a non-reentrancy guard and a source of messaging context
the context includes the remote eid and the sender address
it separates the send and receive context to allow messaging receipts (send back on receive())
sendContext​```
modifier sendContext(uint32 _dstEid, address _sender)
```The sendContext modifier sets the execution context for the message being sent. It encodes the context as a combination of the destination endpoint ID (_dstEid) and the sender's address. This context helps track the message's origin and ensures that only authorized parties can interact with it.
the sendContext is set to 8 bytes 0s + 4 bytes eid + 20 bytes sender
isSendingMessage​```
function isSendingMessage() public view returns (bool)
```The isSendingMessage function returns true if the contract is in the process of sending a message. It helps prevent reentrant calls during message processing.
returns true if sending message
getSendContext​```
function getSendContext() external view returns (uint32, address)
```The getSendContext function retrieves the current send context, returning the destination endpoint ID and sender's address if a message is being sent. If no message is being sent, it returns (0, 0).
returns (eid, sender) if sending message, (0, 0) otherwise
_getSendContext​```
function _getSendContext(uint256 _context) internal pure returns (uint32, address)
```The _getSendContext function decodes the provided _context into its component parts: the destination endpoint ID and the sender's address. This function is used internally to reconstruct the message context when needed.
ILayerZeroComposer​
ILayerZeroComposer defines the interface for composing messages in LayerZero. It standardizes how OApps send composed messages and ensures non-reentrancy.
lzCompose​```
function lzCompose(address _from, bytes32 _guid, bytes _message, address _executor, bytes _extraData) external payable
```The lzCompose function is responsible for composing LayerZero messages from an OApp. To ensure that reentrancy is avoided, this function asserts that msg.sender is the corresponding EndpointV2 contract and from the correct OApp.
To ensure non-reentrancy, implementers of this interface MUST assert msg.sender is the corresponding EndpointV2 contract (i.e., onlyEndpointV2).
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_from | address | The address initiating the composition, typically the OApp where the lzReceive was called.
_guid | bytes32 | The unique identifier for the corresponding LayerZero src/dst tx.
_message | bytes | The composed message payload in bytes. NOT necessarily the same payload passed via lzReceive.
_executor | address | The address of the executor for the composed message.
_extraData | bytes | Additional arbitrary data in bytes passed by the entity who executes the lzCompose.
--- End Table ---MessagingParams​```
struct MessagingParams {  uint32 dstEid;  bytes32 receiver;  bytes message;  bytes options;  bool payInLzToken;}
```The MessagingParams struct is used to define the parameters required for sending a LayerZero message. These parameters specify the destination endpoint, the message's recipient, the actual message payload, and any additional options for the message.--- Table ---
Name | Type | Description
--- | --- | ---
dstEid | uint32 | The destination endpoint ID for the message. This identifies the chain and endpoint to which the message is being sent.
receiver | bytes32 | The address (in bytes32 format) of the receiver on the destination chain.
message | bytes | The actual message payload to be transmitted.
options | bytes | Additional options for the message, such as execution settings or gas limitations.
payInLzToken | bool | A boolean indicating whether the fees for the message will be paid in LayerZero (LZ) tokens.
--- End Table ---MessagingReceipt​```
struct MessagingReceipt {  bytes32 guid;  uint64 nonce;  struct MessagingFee fee;}
```The MessagingReceipt struct provides information about a successfully sent LayerZero message, including a unique identifier (GUID), the nonce, and the fee details.
MessagingFee​```
struct MessagingFee {  uint256 nativeFee;  uint256 lzTokenFee;}
```The MessagingFee struct details the costs involved in sending a message, specifying the native token fee and the fee in LayerZero tokens (if applicable).
Origin​```
struct Origin {  uint32 srcEid;  bytes32 sender;  uint64 nonce;}
```The Origin struct provides details about the source of a LayerZero message, including the source endpoint ID, the sender's address, and the message's nonce.
ILayerZeroEndpointV2​
This interface defines the main interaction points for the LayerZero V2 protocol, which includes message quoting, sending, verification, and event logging for the protocol.
PacketSent​```
event PacketSent(bytes encodedPayload, bytes options, address sendLibrary)
```Emitted when a message packet is sent to a destination endpoint.
PacketVerified​```
event PacketVerified(struct Origin origin, address receiver, bytes32 payloadHash)
```Emitted when a message packet is verified on the destination endpoint.
PacketDelivered​```
event PacketDelivered(struct Origin origin, address receiver)
```Emitted when a message packet is successfully delivered to the destination receiver.
LzReceiveAlert​```
event LzReceiveAlert(address receiver, address executor, struct Origin origin, bytes32 guid, uint256 gas, uint256 value, bytes message, bytes extraData, bytes reason)
```Emitted when an issue occurs during the receipt of a message, such as insufficient gas or a failure in message execution.
LzTokenSet​```
event LzTokenSet(address token)
```Emitted when the LayerZero token address is set or updated.
DelegateSet​```
event DelegateSet(address sender, address delegate)
```Emitted when a delegate is authorized by an OApp to configure LayerZero settings.
quote​```
function quote(struct MessagingParams _params, address _sender) external view returns (struct MessagingFee)
```send​```
function send(struct MessagingParams _params, address _refundAddress) external payable returns (struct MessagingReceipt)
```verify​```
function verify(struct Origin _origin, address _receiver, bytes32 _payloadHash) external
```verifiable​```
function verifiable(struct Origin _origin, address _receiver) external view returns (bool)
```initializable​```
function initializable(struct Origin _origin, address _receiver) external view returns (bool)
```lzReceive​```
function lzReceive(struct Origin _origin, address _receiver, bytes32 _guid, bytes _message, bytes _extraData) external payable
```clear​```
function clear(address _oapp, struct Origin _origin, bytes32 _guid, bytes _message) external
```setLzToken​```
function setLzToken(address _lzToken) external
```lzToken​```
function lzToken() external view returns (address)
```nativeToken​```
function nativeToken() external view returns (address)
```setDelegate​```
function setDelegate(address _delegate) external
```ILayerZeroReceiver​
This interface defines the core message-receiving functionality on LayerZero to be implemented by receiver applications.
allowInitializePath​```
function allowInitializePath(struct Origin _origin) external view returns (bool)
```Returns whether the path from the origin can be initialized.
nextNonce​```
function nextNonce(uint32 _eid, bytes32 _sender) external view returns (uint64)
```Returns the next nonce for a sender on the specified endpoint.
lzReceive​```
function lzReceive(struct Origin _origin, bytes32 _guid, bytes _message, address _executor, bytes _extraData) external payable
```Processes the received message on the destination chain.
MessageLibType​```
enum MessageLibType {  Send,  Receive,  SendAndReceive}
```The MessageLibType enum defines the possible types of messaging libraries in LayerZero.• Send: A library that only handles sending messages.
• Receive: A library that only handles receiving messages.
• SendAndReceive: A library that handles both sending and receiving messages.IMessageLib​
The IMessageLib interface defines functions that allow configuration of messaging libraries, checking endpoint support, and obtaining versioning and library type details.
setConfig​```
function setConfig(address _oapp, struct SetConfigParam[] _config) external
```Allows an OApp (Omnichain Application) to set configuration parameters for a specific messaging library.
getConfig​```
function getConfig(uint32 _eid, address _oapp, uint32 _configType) external view returns (bytes config)
```Fetches the configuration of an OApp for a specific endpoint and configuration type.
isSupportedEid​```
function isSupportedEid(uint32 _eid) external view returns (bool)
```Checks if the messaging library supports a specific endpoint ID (_eid).
version​```
function version() external view returns (uint64 major, uint8 minor, uint8 endpointVersion)
```Returns the version of the messaging library, including the major, minor, and endpoint version numbers.
messageLibType​```
function messageLibType() external view returns (enum MessageLibType)
```Returns the type of the messaging library (Send, Receive, or SendAndReceive) as defined in the MessageLibType enum.
SetConfigParam​```
struct SetConfigParam {  uint32 eid;  uint32 configType;  bytes config;}
```The SetConfigParam struct defines configuration settings for registered Message Libraries.
IMessageLibManager​
The IMessageLibManager interface manages the registration of messaging libraries, setting default libraries, and handling receive library timeouts.
Timeout​```
struct Timeout {  address lib;  uint256 expiry;}
```The Timeout struct defines the expiration settings for a messaging library that has been changed.
LibraryRegistered​```
event LibraryRegistered(address newLib)
```Emitted when a new library is registered.
DefaultSendLibrarySet​```
event DefaultSendLibrarySet(uint32 eid, address newLib)
```Emitted when the default send library is set for a specific endpoint.
DefaultReceiveLibrarySet​```
event DefaultReceiveLibrarySet(uint32 eid, address newLib)
```Emitted when the default receive library is set for a specific endpoint.
DefaultReceiveLibraryTimeoutSet​```
event DefaultReceiveLibraryTimeoutSet(uint32 eid, address oldLib, uint256 expiry)
```Emitted when a timeout is set for the default receive library.
SendLibrarySet​```
event SendLibrarySet(address sender, uint32 eid, address newLib)
```Emitted when a send library is set for an OApp.
ReceiveLibrarySet​```
event ReceiveLibrarySet(address receiver, uint32 eid, address newLib)
```Emitted when a receive library is set for an OApp.
ReceiveLibraryTimeoutSet​```
event ReceiveLibraryTimeoutSet(address receiver, uint32 eid, address oldLib, uint256 timeout)
```Emitted when a receive library timeout is set for an OApp.
registerLibrary​```
function registerLibrary(address _lib) external
```Registers a new messaging library that will be available for endpoints.
isRegisteredLibrary​```
function isRegisteredLibrary(address _lib) external view returns (bool)
```Checks if a messaging library is registered.
getRegisteredLibraries​```
function getRegisteredLibraries() external view returns (address[])
```Returns a list of all registered libraries.
setDefaultSendLibrary​```
function setDefaultSendLibrary(uint32 _eid, address _newLib) external
```Sets the default send library for a specific endpoint.
defaultSendLibrary​```
function defaultSendLibrary(uint32 _eid) external view returns (address)
```Gets the current default send library for a specific endpoint.
setDefaultReceiveLibrary​```
function setDefaultReceiveLibrary(uint32 _eid, address _newLib, uint256 _gracePeriod) external
```Sets the default receive library for a specific endpoint and specifies a grace period for migration.
defaultReceiveLibrary​```
function defaultReceiveLibrary(uint32 _eid) external view returns (address)
```Gets the current default receive library for a specific endpoint.
setDefaultReceiveLibraryTimeout​```
function setDefaultReceiveLibraryTimeout(uint32 _eid, address _lib, uint256 _expiry) external
```Sets the timeout for a default receive library.
defaultReceiveLibraryTimeout​```
function defaultReceiveLibraryTimeout(uint32 _eid) external view returns (address lib, uint256 expiry)
```Gets the default receive library timeout for a specific endpoint.
isSupportedEid​```
function isSupportedEid(uint32 _eid) external view returns (bool)
```isValidReceiveLibrary​```
function isValidReceiveLibrary(address _receiver, uint32 _eid, address _lib) external view returns (bool)
```setSendLibrary​```
function setSendLibrary(address _oapp, uint32 _eid, address _newLib) external
```Sets a send library for an OApp for a specific endpoint.
getSendLibrary​```
function getSendLibrary(address _sender, uint32 _eid) external view returns (address lib)
```isDefaultSendLibrary​```
function isDefaultSendLibrary(address _sender, uint32 _eid) external view returns (bool)
```setReceiveLibrary​```
function setReceiveLibrary(address _oapp, uint32 _eid, address _newLib, uint256 _gracePeriod) external
```getReceiveLibrary​```
function getReceiveLibrary(address _receiver, uint32 _eid) external view returns (address lib, bool isDefault)
```setReceiveLibraryTimeout​```
function setReceiveLibraryTimeout(address _oapp, uint32 _eid, address _lib, uint256 _expiry) external
```receiveLibraryTimeout​```
function receiveLibraryTimeout(address _receiver, uint32 _eid) external view returns (address lib, uint256 expiry)
```setConfig​```
function setConfig(address _oapp, address _lib, struct SetConfigParam[] _params) external
```getConfig​```
function getConfig(address _oapp, address _lib, uint32 _eid, uint32 _configType) external view returns (bytes config)
```IMessagingChannel​
InboundNonceSkipped​```
event InboundNonceSkipped(uint32 srcEid, bytes32 sender, address receiver, uint64 nonce)
```PacketNilified​```
event PacketNilified(uint32 srcEid, bytes32 sender, address receiver, uint64 nonce, bytes32 payloadHash)
```PacketBurnt​```
event PacketBurnt(uint32 srcEid, bytes32 sender, address receiver, uint64 nonce, bytes32 payloadHash)
```eid​```
function eid() external view returns (uint32)
```skip​```
function skip(address _oapp, uint32 _srcEid, bytes32 _sender, uint64 _nonce) external
```nilify​```
function nilify(address _oapp, uint32 _srcEid, bytes32 _sender, uint64 _nonce, bytes32 _payloadHash) external
```burn​```
function burn(address _oapp, uint32 _srcEid, bytes32 _sender, uint64 _nonce, bytes32 _payloadHash) external
```nextGuid​```
function nextGuid(address _sender, uint32 _dstEid, bytes32 _receiver) external view returns (bytes32)
```inboundNonce​```
function inboundNonce(address _receiver, uint32 _srcEid, bytes32 _sender) external view returns (uint64)
```outboundNonce​```
function outboundNonce(address _sender, uint32 _dstEid, bytes32 _receiver) external view returns (uint64)
```inboundPayloadHash​```
function inboundPayloadHash(address _receiver, uint32 _srcEid, bytes32 _sender, uint64 _nonce) external view returns (bytes32)
```lazyInboundNonce​```
function lazyInboundNonce(address _receiver, uint32 _srcEid, bytes32 _sender) external view returns (uint64)
```IMessagingComposer​
ComposeSent​```
event ComposeSent(address from, address to, bytes32 guid, uint16 index, bytes message)
```ComposeDelivered​```
event ComposeDelivered(address from, address to, bytes32 guid, uint16 index)
```LzComposeAlert​```
event LzComposeAlert(address from, address to, address executor, bytes32 guid, uint16 index, uint256 gas, uint256 value, bytes message, bytes extraData, bytes reason)
```composeQueue​```
function composeQueue(address _from, address _to, bytes32 _guid, uint16 _index) external view returns (bytes32 messageHash)
```sendCompose​```
function sendCompose(address _to, bytes32 _guid, uint16 _index, bytes _message) external
```lzCompose​```
function lzCompose(address _from, address _to, bytes32 _guid, uint16 _index, bytes _message, bytes _extraData) external payable
```IMessagingContext​
isSendingMessage​```
function isSendingMessage() external view returns (bool)
```getSendContext​```
function getSendContext() external view returns (uint32 dstEid, address sender)
```Packet​```
struct Packet {  uint64 nonce;  uint32 srcEid;  address sender;  uint32 dstEid;  bytes32 receiver;  bytes32 guid;  bytes message;}
```The Packet struct represents the data structure used for LayerZero messaging between endpoints. It includes important metadata such as sender, receiver, nonce, and the message itself.
ISendLib​
The ISendLib interface defines the functions necessary for sending packets, estimating messaging fees, and handling fee withdrawals for LayerZero messaging.
send​```
function send(struct Packet _packet, bytes _options, bool _payInLzToken) external returns (struct MessagingFee, bytes encodedPacket)
```Sends a LayerZero message packet and returns the required fees and the encoded packet data.• _packet: The Packet struct containing the message to be sent.
• _options: Byte-encoded options for the message.
• _payInLzToken: Boolean flag indicating whether fees should be paid in LzToken.Returns:• MessagingFee: The fees for the message, divided into native and LzToken fees.
• encodedPacket: The encoded message packet in bytes.quote​```
function quote(struct Packet _packet, bytes _options, bool _payInLzToken) external view returns (struct MessagingFee)
```Estimates the messaging fee for sending a LayerZero packet.
setTreasury​```
function setTreasury(address _treasury) external
```Sets the treasury address to receive collected fees.
withdrawFee​```
function withdrawFee(address _to, uint256 _amount) external
```Withdraws native token fees collected by the contract.
withdrawLzTokenFee​```
function withdrawLzTokenFee(address _lzToken, address _to, uint256 _amount) external
```Withdraws LayerZero token fees collected by the contract.
AddressCast​
The AddressCast library provides utility functions for casting between addresses and their byte representations. It also includes error handling for invalid address sizes.
AddressCast_InvalidSizeForAddress​```
error AddressCast_InvalidSizeForAddress()
```Thrown when the size of the byte array for an address is invalid.
AddressCast_InvalidAddress​```
error AddressCast_InvalidAddress()
```Thrown when an invalid address is provided.
toBytes32​```
function toBytes32(bytes _addressBytes) internal pure returns (bytes32 result)
```Casts a byte array to a bytes32 representation of an address.
toBytes32​```
function toBytes32(address _address) internal pure returns (bytes32 result)
```Casts an address to its bytes32 representation.
toBytes​```
function toBytes(bytes32 _addressBytes32, uint256 _size) internal pure returns (bytes result)
```Casts a bytes32 address to its byte array form, with a specified size.
toAddress​```
function toAddress(bytes32 _addressBytes32) internal pure returns (address result)
```Casts a bytes32 representation of an address back to an address.
toAddress​```
function toAddress(bytes _addressBytes) internal pure returns (address result)
```Casts a byte array back to an address.
CalldataBytesLib​
The CalldataBytesLib provides functions to convert portions of calldata (byte arrays) into various Solidity types. These functions help when dealing with raw calldata.
toU8​```
function toU8(bytes _bytes, uint256 _start) internal pure returns (uint8)
```Converts a portion of a byte array to a uint8 starting at the given position.
toU16​```
function toU16(bytes _bytes, uint256 _start) internal pure returns (uint16)
```Converts a portion of a byte array to a uint16 starting at the given position.
toU32​```
function toU32(bytes _bytes, uint256 _start) internal pure returns (uint32)
```Converts a portion of a byte array to a uint32 starting at the given position.
toU64​```
function toU64(bytes _bytes, uint256 _start) internal pure returns (uint64)
```Converts a portion of a byte array to a uint64 starting at the given position.
toU128​```
function toU128(bytes _bytes, uint256 _start) internal pure returns (uint128)
```Converts a portion of a byte array to a uint128 starting at the given position.
toU256​```
function toU256(bytes _bytes, uint256 _start) internal pure returns (uint256)
```Converts a portion of a byte array to a uint256 starting at the given position.
toAddr​```
function toAddr(bytes _bytes, uint256 _start) internal pure returns (address)
```Converts a portion of a byte array to an address starting at the given position.
toB32​```
function toB32(bytes _bytes, uint256 _start) internal pure returns (bytes32)
```Converts a portion of a byte array to a bytes32 starting at the given position.
Errors​
LZ_LzTokenUnavailable​```
error LZ_LzTokenUnavailable()
```LZ_InvalidReceiveLibrary​```
error LZ_InvalidReceiveLibrary()
```LZ_InvalidNonce​```
error LZ_InvalidNonce(uint64 nonce)
```LZ_InvalidArgument​```
error LZ_InvalidArgument()
```LZ_InvalidExpiry​```
error LZ_InvalidExpiry()
```LZ_InvalidAmount​```
error LZ_InvalidAmount(uint256 required, uint256 supplied)
```LZ_OnlyRegisteredOrDefaultLib​```
error LZ_OnlyRegisteredOrDefaultLib()
```LZ_OnlyRegisteredLib​```
error LZ_OnlyRegisteredLib()
```LZ_OnlyNonDefaultLib​```
error LZ_OnlyNonDefaultLib()
```LZ_Unauthorized​```
error LZ_Unauthorized()
```LZ_DefaultSendLibUnavailable​```
error LZ_DefaultSendLibUnavailable()
```LZ_DefaultReceiveLibUnavailable​```
error LZ_DefaultReceiveLibUnavailable()
```LZ_PathNotInitializable​```
error LZ_PathNotInitializable()
```LZ_PathNotVerifiable​```
error LZ_PathNotVerifiable()
```LZ_OnlySendLib​```
error LZ_OnlySendLib()
```LZ_OnlyReceiveLib​```
error LZ_OnlyReceiveLib()
```LZ_UnsupportedEid​```
error LZ_UnsupportedEid()
```LZ_UnsupportedInterface​```
error LZ_UnsupportedInterface()
```LZ_AlreadyRegistered​```
error LZ_AlreadyRegistered()
```LZ_SameValue​```
error LZ_SameValue()
```LZ_InvalidPayloadHash​```
error LZ_InvalidPayloadHash()
```LZ_PayloadHashNotFound​```
error LZ_PayloadHashNotFound(bytes32 expected, bytes32 actual)
```LZ_ComposeNotFound​```
error LZ_ComposeNotFound(bytes32 expected, bytes32 actual)
```LZ_ComposeExists​```
error LZ_ComposeExists()
```LZ_SendReentrancy​```
error LZ_SendReentrancy()
```LZ_NotImplemented​```
error LZ_NotImplemented()
```LZ_InsufficientFee​```
error LZ_InsufficientFee(uint256 requiredNative, uint256 suppliedNative, uint256 requiredLzToken, uint256 suppliedLzToken)
```LZ_ZeroLzTokenFee​```
error LZ_ZeroLzTokenFee()
```GUID​
generate​```
function generate(uint64 _nonce, uint32 _srcEid, address _sender, uint32 _dstEid, bytes32 _receiver) internal pure returns (bytes32)
```Transfer​
ADDRESS_ZERO​```
address ADDRESS_ZERO
```Transfer_NativeFailed​```
error Transfer_NativeFailed(address _to, uint256 _value)
```Transfer_ToAddressIsZero​```
error Transfer_ToAddressIsZero()
```native​```
function native(address _to, uint256 _value) internal
```token​```
function token(address _token, address _to, uint256 _value) internal
```nativeOrToken​```
function nativeOrToken(address _token, address _to, uint256 _value) internal
```BlockedMessageLib​
supportsInterface​```
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```See IERC165 and supportsInterface.
version​```
function version() external pure returns (uint64 major, uint8 minor, uint8 endpointVersion)
```messageLibType​```
function messageLibType() external pure returns (enum MessageLibType)
```isSupportedEid​```
function isSupportedEid(uint32) external pure returns (bool)
```fallback​```
fallback() external
```BitMaps​
get​```
function get(BitMap256 bitmap, uint8 index) internal pure returns (bool)
```Returns whether the bit at index is set.
set​```
function set(BitMap256 bitmap, uint8 index) internal pure returns (BitMap256)
```Sets the bit at index.
ExecutorOptions​
WORKER_ID​```
uint8 WORKER_ID
```OPTION_TYPE_LZRECEIVE​```
uint8 OPTION_TYPE_LZRECEIVE
```OPTION_TYPE_NATIVE_DROP​```
uint8 OPTION_TYPE_NATIVE_DROP
```OPTION_TYPE_LZCOMPOSE​```
uint8 OPTION_TYPE_LZCOMPOSE
```OPTION_TYPE_ORDERED_EXECUTION​```
uint8 OPTION_TYPE_ORDERED_EXECUTION
```Executor_InvalidLzReceiveOption​```
error Executor_InvalidLzReceiveOption()
```Executor_InvalidNativeDropOption​```
error Executor_InvalidNativeDropOption()
```Executor_InvalidLzComposeOption​```
error Executor_InvalidLzComposeOption()
```nextExecutorOption​```
function nextExecutorOption(bytes _options, uint256 _cursor) internal pure returns (uint8 optionType, bytes option, uint256 cursor)
```decode the next executor option from the options starting from the specified cursor
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_options | bytes | [executor_id][executor_option][executor_id][executor_option]... executor_option = [option_size][option_type][option] option_size = len(option_type) + len(option) executor_id: uint8, option_size: uint16, option_type: uint8, option: bytes
_cursor | uint256 | the cursor to start decoding from
--- End Table ---Return Values​--- Table ---
Name | Type | Description
--- | --- | ---
optionType | uint8 | the type of the option
option | bytes | the option of the executor
cursor | uint256 | the cursor to start decoding the next executor option
--- End Table ---decodeLzReceiveOption​```
function decodeLzReceiveOption(bytes _option) internal pure returns (uint128 gas, uint128 value)
```decodeNativeDropOption​```
function decodeNativeDropOption(bytes _option) internal pure returns (uint128 amount, bytes32 receiver)
```decodeLzComposeOption​```
function decodeLzComposeOption(bytes _option) internal pure returns (uint16 index, uint128 gas, uint128 value)
```encodeLzReceiveOption​```
function encodeLzReceiveOption(uint128 _gas, uint128 _value) internal pure returns (bytes)
```encodeNativeDropOption​```
function encodeNativeDropOption(uint128 _amount, bytes32 _receiver) internal pure returns (bytes)
```encodeLzComposeOption​```
function encodeLzComposeOption(uint16 _index, uint128 _gas, uint128 _value) internal pure returns (bytes)
```PacketV1Codec​
PACKET_VERSION​```
uint8 PACKET_VERSION
```encode​```
function encode(struct Packet _packet) internal pure returns (bytes encodedPacket)
```encodePacketHeader​```
function encodePacketHeader(struct Packet _packet) internal pure returns (bytes)
```encodePayload​```
function encodePayload(struct Packet _packet) internal pure returns (bytes)
```header​```
function header(bytes _packet) internal pure returns (bytes)
```version​```
function version(bytes _packet) internal pure returns (uint8)
```nonce​```
function nonce(bytes _packet) internal pure returns (uint64)
```srcEid​```
function srcEid(bytes _packet) internal pure returns (uint32)
```sender​```
function sender(bytes _packet) internal pure returns (bytes32)
```senderAddressB20​```
function senderAddressB20(bytes _packet) internal pure returns (address)
```dstEid​```
function dstEid(bytes _packet) internal pure returns (uint32)
```receiver​```
function receiver(bytes _packet) internal pure returns (bytes32)
```receiverB20​```
function receiverB20(bytes _packet) internal pure returns (address)
```guid​```
function guid(bytes _packet) internal pure returns (bytes32)
```message​```
function message(bytes _packet) internal pure returns (bytes)
```payload​```
function payload(bytes _packet) internal pure returns (bytes)
```payloadHash​```
function payloadHash(bytes _packet) internal pure returns (bytes32)
```MessageLibBase​
This contract serves as a base for handling the communication between the LayerZero endpoint and a specific chain (referred to by its localEid). It simplifies the initialization and enforcement of endpoint-specific logic.
simply a container of endpoint address and local eid
endpoint​```
address endpoint
```Holds the address of the LayerZero endpoint on this chain.
localEid​```
uint32 localEid
```A unique identifier (Eid) for the local chain.
LZ_MessageLib_OnlyEndpoint​```
error LZ_MessageLib_OnlyEndpoint()
```Error thrown when a function is accessed by a non-endpoint address.
onlyEndpoint​```
modifier onlyEndpoint()
```A modifier ensuring that only the LayerZero endpoint can call specific functions.
constructor​```
constructor(address _endpoint, uint32 _localEid) internal
```Initializes the contract with the LayerZero endpoint and localEid.
ReceiveLibBaseE2​
This is the base contract for handling the receive-side logic of messages in LayerZero V2. It simplifies the process compared to V1 by removing complexities like nonce management and executor whitelisting.
receive-side message library base contract on endpoint v2.
it does not have the complication as the one of endpoint v1, such as nonce, executor whitelist, etc.
constructor​```
constructor(address _endpoint) internal
```Initializes the contract with the LayerZero endpoint.
supportsInterface​```
function supportsInterface(bytes4 _interfaceId) public view virtual returns (bool)
```Determines whether the contract supports a specific interface.
messageLibType​```
function messageLibType() external pure virtual returns (enum MessageLibType)
```Specifies the type of the message library being used (e.g., for differentiation between send and receive libraries).
WorkerOptions​```
struct WorkerOptions {  uint8 workerId;  bytes options;}
```Defines options for specific worker configurations (e.g., a worker ID and additional options).
SetDefaultExecutorConfigParam​```
struct SetDefaultExecutorConfigParam {  uint32 eid;  struct ExecutorConfig config;}
```Used to configure the default settings for an executor, including the executor's address and max message size for a given chain (eid).
ExecutorConfig​```
struct ExecutorConfig {  uint32 maxMessageSize;  address executor;}
```SendLibBase​
base contract for both SendLibBaseE1 and SendLibBaseE2
TREASURY_MAX_COPY​```
uint16 TREASURY_MAX_COPY
```treasuryGasLimit​```
uint256 treasuryGasLimit
```treasuryNativeFeeCap​```
uint256 treasuryNativeFeeCap
```treasury​```
address treasury
```executorConfigs​```
mapping(address => mapping(uint32 => struct ExecutorConfig)) executorConfigs
```fees​```
mapping(address => uint256) fees
```ExecutorFeePaid​```
event ExecutorFeePaid(address executor, uint256 fee)
```TreasurySet​```
event TreasurySet(address treasury)
```DefaultExecutorConfigsSet​```
event DefaultExecutorConfigsSet(struct SetDefaultExecutorConfigParam[] params)
```ExecutorConfigSet​```
event ExecutorConfigSet(address oapp, uint32 eid, struct ExecutorConfig config)
```TreasuryNativeFeeCapSet​```
event TreasuryNativeFeeCapSet(uint256 newTreasuryNativeFeeCap)
```LZ_MessageLib_InvalidMessageSize​```
error LZ_MessageLib_InvalidMessageSize(uint256 actual, uint256 max)
```LZ_MessageLib_InvalidAmount​```
error LZ_MessageLib_InvalidAmount(uint256 requested, uint256 available)
```LZ_MessageLib_TransferFailed​```
error LZ_MessageLib_TransferFailed()
```LZ_MessageLib_InvalidExecutor​```
error LZ_MessageLib_InvalidExecutor()
```LZ_MessageLib_ZeroMessageSize​```
error LZ_MessageLib_ZeroMessageSize()
```constructor​```
constructor(address _endpoint, uint32 _localEid, uint256 _treasuryGasLimit, uint256 _treasuryNativeFeeCap) internal
```setDefaultExecutorConfigs​```
function setDefaultExecutorConfigs(struct SetDefaultExecutorConfigParam[] _params) external
```setTreasuryNativeFeeCap​```
function setTreasuryNativeFeeCap(uint256 _newTreasuryNativeFeeCap) external
```the new value can not be greater than the old value, i.e. down only
getExecutorConfig​```
function getExecutorConfig(address _oapp, uint32 _remoteEid) public view returns (struct ExecutorConfig rtnConfig)
```_assertMessageSize​```
function _assertMessageSize(uint256 _actual, uint256 _max) internal pure
```_payExecutor​```
function _payExecutor(address _executor, uint32 _dstEid, address _sender, uint256 _msgSize, bytes _executorOptions) internal returns (uint256 executorFee)
```_payTreasury​```
function _payTreasury(address _sender, uint32 _dstEid, uint256 _totalNativeFee, bool _payInLzToken) internal returns (uint256 treasuryNativeFee, uint256 lzTokenFee)
```_quote​```
function _quote(address _sender, uint32 _dstEid, uint256 _msgSize, bool _payInLzToken, bytes _options) internal view returns (uint256, uint256)
```the abstract process for quote() is:
0/ split out the executor options and options of other workers
1/ quote workers
2/ quote executor
3/ quote treasury
Return Values​--- Table ---
Name | Type | Description
--- | --- | ---
[0] | uint256 | nativeFee, lzTokenFee
[1] | uint256 |
--- End Table ---_quoteTreasury​```
function _quoteTreasury(address _sender, uint32 _dstEid, uint256 _totalNativeFee, bool _payInLzToken) internal view returns (uint256 nativeFee, uint256 lzTokenFee)
```this interface should be DoS-free if the user is paying with native. properties
1/ treasury can return an overly high lzToken fee
2/ if treasury returns an overly high native fee, it will be capped by maxNativeFee,
which can be reasoned with the configurations
3/ the owner can not configure the treasury in a way that force this function to revert
_parseTreasuryResult​```
function _parseTreasuryResult(uint256 _totalNativeFee, bool _payInLzToken, bool _success, bytes _result) internal view returns (uint256 nativeFee, uint256 lzTokenFee)
```_debitFee​```
function _debitFee(uint256 _amount) internal
```authenticated by msg.sender only
_setTreasury​```
function _setTreasury(address _treasury) internal
```_setExecutorConfig​```
function _setExecutorConfig(uint32 _remoteEid, address _oapp, struct ExecutorConfig _config) internal
```_quoteVerifier​```
function _quoteVerifier(address _oapp, uint32 _eid, struct WorkerOptions[] _options) internal view virtual returns (uint256 nativeFee)
```these two functions will be overridden with specific logics of the library function
_splitOptions​```
function _splitOptions(bytes _options) internal view virtual returns (bytes executorOptions, struct WorkerOptions[] validationOptions)
```this function will split the options into executorOptions and validationOptions
SendLibBaseE2​
send-side message library base contract on endpoint v2.
design: the high level logic is the same as SendLibBaseE1
1/ with added interfaces
2/ adapt the functions to the new types, like uint32 for eid, address for sender.
NativeFeeWithdrawn​```
event NativeFeeWithdrawn(address worker, address receiver, uint256 amount)
```LzTokenFeeWithdrawn​```
event LzTokenFeeWithdrawn(address lzToken, address receiver, uint256 amount)
```LZ_MessageLib_NotTreasury​```
error LZ_MessageLib_NotTreasury()
```LZ_MessageLib_CannotWithdrawAltToken​```
error LZ_MessageLib_CannotWithdrawAltToken()
```constructor​```
constructor(address _endpoint, uint256 _treasuryGasLimit, uint256 _treasuryNativeFeeCap) internal
```supportsInterface​```
function supportsInterface(bytes4 _interfaceId) public view virtual returns (bool)
```send​```
function send(struct Packet _packet, bytes _options, bool _payInLzToken) public virtual returns (struct MessagingFee, bytes)
```setTreasury​```
function setTreasury(address _treasury) external
```withdrawFee​```
function withdrawFee(address _to, uint256 _amount) external
```E2 only
withdrawLzTokenFee​```
function withdrawLzTokenFee(address _lzToken, address _to, uint256 _amount) external
```_lzToken is a user-supplied value because lzToken might change in the endpoint before all lzToken can be taken out
E2 only
treasury only function
quote​```
function quote(struct Packet _packet, bytes _options, bool _payInLzToken) external view returns (struct MessagingFee)
```messageLibType​```
function messageLibType() external pure virtual returns (enum MessageLibType)
```_payWorkers​```
function _payWorkers(struct Packet _packet, bytes _options) internal returns (bytes encodedPacket, uint256 totalNativeFee)
```1/ handle executor
2/ handle other workers
_payVerifier​```
function _payVerifier(struct Packet _packet, struct WorkerOptions[] _options) internal virtual returns (uint256 otherWorkerFees, bytes encodedPacket)
```receive​```
receive() external payable virtual
```Treasury​
nativeBP​```
uint256 nativeBP
```lzTokenFee​```
uint256 lzTokenFee
```lzTokenEnabled​```
bool lzTokenEnabled
```LZ_Treasury_LzTokenNotEnabled​```
error LZ_Treasury_LzTokenNotEnabled()
```getFee​```
function getFee(address, uint32, uint256 _totalFee, bool _payInLzToken) external view returns (uint256)
```payFee​```
function payFee(address, uint32, uint256 _totalFee, bool _payInLzToken) external payable returns (uint256)
```setLzTokenEnabled​```
function setLzTokenEnabled(bool _lzTokenEnabled) external
```setNativeFeeBP​```
function setNativeFeeBP(uint256 _nativeBP) external
```setLzTokenFee​```
function setLzTokenFee(uint256 _lzTokenFee) external
```withdrawLzToken​```
function withdrawLzToken(address _messageLib, address _lzToken, address _to, uint256 _amount) external
```withdrawNativeFee​```
function withdrawNativeFee(address _messageLib, address payable _to, uint256 _amount) external
```withdrawToken​```
function withdrawToken(address _token, address _to, uint256 _amount) external
```_getFee​```
function _getFee(uint256 _totalFee, bool _payInLzToken) internal view returns (uint256)
```Worker​
MESSAGE_LIB_ROLE​```
bytes32 MESSAGE_LIB_ROLE
```ALLOWLIST​```
bytes32 ALLOWLIST
```DENYLIST​```
bytes32 DENYLIST
```ADMIN_ROLE​```
bytes32 ADMIN_ROLE
```workerFeeLib​```
address workerFeeLib
```allowlistSize​```
uint64 allowlistSize
```defaultMultiplierBps​```
uint16 defaultMultiplierBps
```priceFeed​```
address priceFeed
```supportedOptionTypes​```
mapping(uint32 => uint8[]) supportedOptionTypes
```constructor​```
constructor(address[] _messageLibs, address _priceFeed, uint16 _defaultMultiplierBps, address _roleAdmin, address[] _admins) internal
```Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_messageLibs | address[] | array of message lib addresses that are granted the MESSAGE_LIB_ROLE
_priceFeed | address | price feed address
_defaultMultiplierBps | uint16 | default multiplier for worker fee
_roleAdmin | address | address that is granted the DEFAULT_ADMIN_ROLE (can grant and revoke all roles)
_admins | address[] | array of admin addresses that are granted the ADMIN_ROLE
--- End Table ---onlyAcl​```
modifier onlyAcl(address _sender)
```hasAcl​```
function hasAcl(address _sender) public view returns (bool)
```_Access control list using allowlist and denylist1. if one address is in the denylist -> deny
2. else if address in the allowlist OR allowlist is empty (allows everyone)-> allow
3. else deny_Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_sender | address | address to check
--- End Table ---setPaused​```
function setPaused(bool _paused) external
```flag to pause execution of workers (if used with whenNotPaused modifier)
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_paused | bool | true to pause, false to unpause
--- End Table ---setPriceFeed​```
function setPriceFeed(address _priceFeed) external
```Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_priceFeed | address | price feed address
--- End Table ---setWorkerFeeLib​```
function setWorkerFeeLib(address _workerFeeLib) external
```Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_workerFeeLib | address | worker fee lib address
--- End Table ---setDefaultMultiplierBps​```
function setDefaultMultiplierBps(uint16 _multiplierBps) external
```Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_multiplierBps | uint16 | default multiplier for worker fee
--- End Table ---withdrawFee​```
function withdrawFee(address _lib, address _to, uint256 _amount) external
```supports withdrawing fee from ULN301, ULN302 and more
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_lib | address | message lib address
_to | address | address to withdraw fee to
_amount | uint256 | amount to withdraw
--- End Table ---withdrawToken​```
function withdrawToken(address _token, address _to, uint256 _amount) external
```supports withdrawing token from the contract
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_token | address | token address
_to | address | address to withdraw token to
_amount | uint256 | amount to withdraw
--- End Table ---setSupportedOptionTypes​```
function setSupportedOptionTypes(uint32 _eid, uint8[] _optionTypes) external
```getSupportedOptionTypes​```
function getSupportedOptionTypes(uint32 _eid) external view returns (uint8[])
```_grantRole​```
function _grantRole(bytes32 _role, address _account) internal
```overrides AccessControl to allow for counting of allowlistSize
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_role | bytes32 | role to grant
_account | address | address to grant role to
--- End Table ---_revokeRole​```
function _revokeRole(bytes32 _role, address _account) internal
```overrides AccessControl to allow for counting of allowlistSize
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_role | bytes32 | role to revoke
_account | address | address to revoke role from
--- End Table ---renounceRole​```
function renounceRole(bytes32, address) public pure
```overrides AccessControl to disable renouncing of roles
TargetParam​```
struct TargetParam {  uint8 idx;  address addr;}
```DVNParam​```
struct DVNParam {  uint16 idx;  address addr;}
```IExecutor​
DstConfigParam​```
struct DstConfigParam {  uint32 dstEid;  uint64 lzReceiveBaseGas;  uint64 lzComposeBaseGas;  uint16 multiplierBps;  uint128 floorMarginUSD;  uint128 nativeCap;}
```DstConfig​```
struct DstConfig {  uint64 lzReceiveBaseGas;  uint16 multiplierBps;  uint128 floorMarginUSD;  uint128 nativeCap;  uint64 lzComposeBaseGas;}
```ExecutionParams​```
struct ExecutionParams {  address receiver;  struct Origin origin;  bytes32 guid;  bytes message;  bytes extraData;  uint256 gasLimit;}
```NativeDropParams​```
struct NativeDropParams {  address receiver;  uint256 amount;}
```DstConfigSet​```
event DstConfigSet(struct IExecutor.DstConfigParam[] params)
```NativeDropApplied​```
event NativeDropApplied(struct Origin origin, uint32 dstEid, address oapp, struct IExecutor.NativeDropParams[] params, bool[] success)
```dstConfig​```
function dstConfig(uint32 _dstEid) external view returns (uint64, uint16, uint128, uint128, uint64)
```IExecutorFeeLib​
FeeParams​```
struct FeeParams {  address priceFeed;  uint32 dstEid;  address sender;  uint256 calldataSize;  uint16 defaultMultiplierBps;}
```Executor_NoOptions​```
error Executor_NoOptions()
```Executor_NativeAmountExceedsCap​```
error Executor_NativeAmountExceedsCap(uint256 amount, uint256 cap)
```Executor_UnsupportedOptionType​```
error Executor_UnsupportedOptionType(uint8 optionType)
```Executor_InvalidExecutorOptions​```
error Executor_InvalidExecutorOptions(uint256 cursor)
```Executor_ZeroLzReceiveGasProvided​```
error Executor_ZeroLzReceiveGasProvided()
```Executor_ZeroLzComposeGasProvided​```
error Executor_ZeroLzComposeGasProvided()
```Executor_EidNotSupported​```
error Executor_EidNotSupported(uint32 eid)
```getFeeOnSend​```
function getFeeOnSend(struct IExecutorFeeLib.FeeParams _params, struct IExecutor.DstConfig _dstConfig, bytes _options) external returns (uint256 fee)
```getFee​```
function getFee(struct IExecutorFeeLib.FeeParams _params, struct IExecutor.DstConfig _dstConfig, bytes _options) external view returns (uint256 fee)
```ILayerZeroExecutor​
assignJob​```
function assignJob(uint32 _dstEid, address _sender, uint256 _calldataSize, bytes _options) external returns (uint256 price)
```getFee​```
function getFee(uint32 _dstEid, address _sender, uint256 _calldataSize, bytes _options) external view returns (uint256 price)
```ILayerZeroTreasury​
getFee​```
function getFee(address _sender, uint32 _dstEid, uint256 _totalNativeFee, bool _payInLzToken) external view returns (uint256 fee)
```payFee​```
function payFee(address _sender, uint32 _dstEid, uint256 _totalNativeFee, bool _payInLzToken) external payable returns (uint256 fee)
```IWorker​
SetWorkerLib​```
event SetWorkerLib(address workerLib)
```SetPriceFeed​```
event SetPriceFeed(address priceFeed)
```SetDefaultMultiplierBps​```
event SetDefaultMultiplierBps(uint16 multiplierBps)
```SetSupportedOptionTypes​```
event SetSupportedOptionTypes(uint32 dstEid, uint8[] optionTypes)
```Withdraw​```
event Withdraw(address lib, address to, uint256 amount)
```Worker_NotAllowed​```
error Worker_NotAllowed()
```Worker_OnlyMessageLib​```
error Worker_OnlyMessageLib()
```Worker_RoleRenouncingDisabled​```
error Worker_RoleRenouncingDisabled()
```setPriceFeed​```
function setPriceFeed(address _priceFeed) external
```priceFeed​```
function priceFeed() external view returns (address)
```setDefaultMultiplierBps​```
function setDefaultMultiplierBps(uint16 _multiplierBps) external
```defaultMultiplierBps​```
function defaultMultiplierBps() external view returns (uint16)
```withdrawFee​```
function withdrawFee(address _lib, address _to, uint256 _amount) external
```setSupportedOptionTypes​```
function setSupportedOptionTypes(uint32 _eid, uint8[] _optionTypes) external
```getSupportedOptionTypes​```
function getSupportedOptionTypes(uint32 _eid) external view returns (uint8[])
```SafeCall​
copied from https://github.com/nomad-xyz/ExcessivelySafeCall/blob/main/src/ExcessivelySafeCall.sol.
safeCall​```
function safeCall(address _target, uint256 _gas, uint256 _value, uint16 _maxCopy, bytes _calldata) internal returns (bool, bytes)
```calls a contract with a specified gas limit and value and captures the return data
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_target | address | The address to call
_gas | uint256 | The amount of gas to forward to the remote contract
_value | uint256 | The value in wei to send to the remote contract to memory.
_maxCopy | uint16 | The maximum number of bytes of returndata to copy to memory.
_calldata | bytes | The data to send to the remote contract
--- End Table ---Return Values​--- Table ---
Name | Type | Description
--- | --- | ---
[0] | bool | success and returndata, as .call(). Returndata is capped to _maxCopy bytes.
[1] | bytes |
--- End Table ---safeStaticCall​```
function safeStaticCall(address _target, uint256 _gas, uint16 _maxCopy, bytes _calldata) internal view returns (bool, bytes)
```Use when you really really really don't trust the called
contract. This prevents the called contract from causing reversion of
the caller in as many ways as we can.
The main difference between this and a solidity low-level call is
that we limit the number of bytes that the callee can cause to be
copied to caller memory. This prevents stupid things like malicious
contracts returning 10,000,000 bytes causing a local OOG when copying
to memory.
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_target | address | The address to call
_gas | uint256 | The amount of gas to forward to the remote contract
_maxCopy | uint16 | The maximum number of bytes of returndata to copy to memory.
_calldata | bytes | The data to send to the remote contract
--- End Table ---Return Values​--- Table ---
Name | Type | Description
--- | --- | ---
[0] | bool | success and returndata, as .call(). Returndata is capped to _maxCopy bytes.
[1] | bytes |
--- End Table ---DVNMock​
Executed​```
event Executed(uint32 vid, address target, bytes callData, uint256 expiration, bytes signatures)
```vid​```
uint32 vid
```constructor​```
constructor(uint32 _vid) public
```execute​```
function execute(struct ExecuteParam[] _params) external
```verify​```
function verify(bytes _packetHeader, bytes32 _payloadHash, uint64 _confirmations) external
```ExecutorMock​
NativeDropMeta​```
event NativeDropMeta(uint32 srcEid, bytes32 sender, uint64 nonce, uint32 dstEid, address oapp, uint256 nativeDropGasLimit)
```NativeDropped​```
event NativeDropped(address receiver, uint256 amount)
```Executed301​```
event Executed301(bytes packet, uint256 gasLimit)
```Executed302​```
event Executed302(uint32 srcEid, bytes32 sender, uint64 nonce, address receiver, bytes32 guid, bytes message, bytes extraData, uint256 gasLimit)
```dstEid​```
uint32 dstEid
```constructor​```
constructor(uint32 _dstEid) public
```nativeDrop​```
function nativeDrop(struct Origin _origin, uint32 _dstEid, address _oapp, struct IExecutor.NativeDropParams[] _nativeDropParams, uint256 _nativeDropGasLimit) external payable
```nativeDropAndExecute301​```
function nativeDropAndExecute301(struct Origin _origin, struct IExecutor.NativeDropParams[] _nativeDropParams, uint256 _nativeDropGasLimit, bytes _packet, uint256 _gasLimit) external payable
```execute301​```
function execute301(bytes _packet, uint256 _gasLimit) external
```nativeDropAndExecute302​```
function nativeDropAndExecute302(struct IExecutor.NativeDropParams[] _nativeDropParams, uint256 _nativeDropGasLimit, struct IExecutor.ExecutionParams _executionParams) external payable
```_nativeDrop​```
function _nativeDrop(struct Origin _origin, uint32 _dstEid, address _oapp, struct IExecutor.NativeDropParams[] _nativeDropParams, uint256 _nativeDropGasLimit) internal
```LzReceiveParam​```
struct LzReceiveParam {  struct Origin origin;  address receiver;  bytes32 guid;  bytes message;  bytes extraData;  uint256 gas;  uint256 value;}
```NativeDropParam​```
struct NativeDropParam {  address _receiver;  uint256 _amount;}
```IReceiveUlnView​
verifiable​```
function verifiable(bytes _packetHeader, bytes32 _payloadHash) external view returns (enum VerificationState)
```Verification​```
struct Verification {  bool submitted;  uint64 confirmations;}
```ReceiveUlnBase​
includes the utility functions for checking ULN states and logics
hashLookup​```
mapping(bytes32 => mapping(bytes32 => mapping(address => struct Verification))) hashLookup
```PayloadVerified​```
event PayloadVerified(address dvn, bytes header, uint256 confirmations, bytes32 proofHash)
```LZ_ULN_InvalidPacketHeader​```
error LZ_ULN_InvalidPacketHeader()
```LZ_ULN_InvalidPacketVersion​```
error LZ_ULN_InvalidPacketVersion()
```LZ_ULN_InvalidEid​```
error LZ_ULN_InvalidEid()
```LZ_ULN_Verifying​```
error LZ_ULN_Verifying()
```verifiable​```
function verifiable(struct UlnConfig _config, bytes32 _headerHash, bytes32 _payloadHash) external view returns (bool)
```assertHeader​```
function assertHeader(bytes _packetHeader, uint32 _localEid) external pure
```_verify​```
function _verify(bytes _packetHeader, bytes32 _payloadHash, uint64 _confirmations) internal
```per DVN signing function
_verified​```
function _verified(address _dvn, bytes32 _headerHash, bytes32 _payloadHash, uint64 _requiredConfirmation) internal view returns (bool verified)
```_verifyAndReclaimStorage​```
function _verifyAndReclaimStorage(struct UlnConfig _config, bytes32 _headerHash, bytes32 _payloadHash) internal
```_assertHeader​```
function _assertHeader(bytes _packetHeader, uint32 _localEid) internal pure
```_checkVerifiable​```
function _checkVerifiable(struct UlnConfig _config, bytes32 _headerHash, bytes32 _payloadHash) internal view returns (bool)
```for verifiable view function
checks if this verification is ready to be committed to the endpoint
SendUlnBase​
includes the utility functions for checking ULN states and logics
DVNFeePaid​```
event DVNFeePaid(address[] requiredDVNs, address[] optionalDVNs, uint256[] fees)
```_splitUlnOptions​```
function _splitUlnOptions(bytes _options) internal pure returns (bytes, struct WorkerOptions[])
```_payDVNs​```
function _payDVNs(mapping(address => uint256) _fees, struct Packet _packet, struct WorkerOptions[] _options) internal returns (uint256 totalFee, bytes encodedPacket)
```---------- pay and assign jobs ----------
_assignJobs​```
function _assignJobs(mapping(address => uint256) _fees, struct UlnConfig _ulnConfig, struct ILayerZeroDVN.AssignJobParam _param, bytes dvnOptions) internal returns (uint256 totalFee, uint256[] dvnFees)
```_quoteDVNs​```
function _quoteDVNs(address _sender, uint32 _dstEid, struct WorkerOptions[] _options) internal view returns (uint256 totalFee)
```---------- quote ----------
_getFees​```
function _getFees(struct UlnConfig _config, uint32 _dstEid, address _sender, bytes[] _optionsArray, uint8[] _dvnIds) internal view returns (uint256 totalFee)
```UlnConfig​```
struct UlnConfig {  uint64 confirmations;  uint8 requiredDVNCount;  uint8 optionalDVNCount;  uint8 optionalDVNThreshold;  address[] requiredDVNs;  address[] optionalDVNs;}
```SetDefaultUlnConfigParam​```
struct SetDefaultUlnConfigParam {  uint32 eid;  struct UlnConfig config;}
```UlnBase​
includes the utility functions for checking ULN states and logics
DEFAULT​```
uint8 DEFAULT
```NIL_DVN_COUNT​```
uint8 NIL_DVN_COUNT
```NIL_CONFIRMATIONS​```
uint64 NIL_CONFIRMATIONS
```ulnConfigs​```
mapping(address => mapping(uint32 => struct UlnConfig)) ulnConfigs
```LZ_ULN_Unsorted​```
error LZ_ULN_Unsorted()
```LZ_ULN_InvalidRequiredDVNCount​```
error LZ_ULN_InvalidRequiredDVNCount()
```LZ_ULN_InvalidOptionalDVNCount​```
error LZ_ULN_InvalidOptionalDVNCount()
```LZ_ULN_AtLeastOneDVN​```
error LZ_ULN_AtLeastOneDVN()
```LZ_ULN_InvalidOptionalDVNThreshold​```
error LZ_ULN_InvalidOptionalDVNThreshold()
```LZ_ULN_InvalidConfirmations​```
error LZ_ULN_InvalidConfirmations()
```LZ_ULN_UnsupportedEid​```
error LZ_ULN_UnsupportedEid(uint32 eid)
```DefaultUlnConfigsSet​```
event DefaultUlnConfigsSet(struct SetDefaultUlnConfigParam[] params)
```UlnConfigSet​```
event UlnConfigSet(address oapp, uint32 eid, struct UlnConfig config)
```setDefaultUlnConfigs​```
function setDefaultUlnConfigs(struct SetDefaultUlnConfigParam[] _params) external
```_about the DEFAULT ULN config1. its values are all LITERAL (e.g. 0 is 0). whereas in the oapp ULN config, 0 (default value) points to the default ULN config
this design enables the oapp to point to DEFAULT config without explicitly setting the config
2. its configuration is more restrictive than the oapp ULN config that
a) it must not use NIL value, where NIL is used only by oapps to indicate the LITERAL 0
b) it must have at least one DVN_getUlnConfig​```
function getUlnConfig(address _oapp, uint32 _remoteEid) public view returns (struct UlnConfig rtnConfig)
```getAppUlnConfig​```
function getAppUlnConfig(address _oapp, uint32 _remoteEid) external view returns (struct UlnConfig)
```Get the uln config without the default config for the given remoteEid.
_setUlnConfig​```
function _setUlnConfig(uint32 _remoteEid, address _oapp, struct UlnConfig _param) internal
```_isSupportedEid​```
function _isSupportedEid(uint32 _remoteEid) internal view returns (bool)
```a supported Eid must have a valid default uln config, which has at least one dvn
_assertSupportedEid​```
function _assertSupportedEid(uint32 _remoteEid) internal view
```ExecuteParam​```
struct ExecuteParam {  uint32 vid;  address target;  bytes callData;  uint256 expiration;  bytes signatures;}
```ISendLibBase​
fees​```
function fees(address _worker) external view returns (uint256)
```IReceiveUln​
verify​```
function verify(bytes _packetHeader, bytes32 _payloadHash, uint64 _confirmations) external
```ReceiveLibParam​```
struct ReceiveLibParam {  address sendLib;  uint32 dstEid;  bytes32 receiveLib;}
```DVNAdapterBase​
base contract for DVN adapters
_limitations:• doesn't accept alt token
• doesn't respect block confirmations_DVNAdapter_InsufficientBalance​```
error DVNAdapter_InsufficientBalance(uint256 actual, uint256 requested)
```DVNAdapter_NotImplemented​```
error DVNAdapter_NotImplemented()
```DVNAdapter_MissingRecieveLib​```
error DVNAdapter_MissingRecieveLib(address sendLib, uint32 dstEid)
```ReceiveLibsSet​```
event ReceiveLibsSet(struct ReceiveLibParam[] params)
```MAX_CONFIRMATIONS​```
uint64 MAX_CONFIRMATIONS
```on change of application config, dvn adapters will not perform any additional verification
to avoid messages from being stuck, all verifications from adapters will be done with the maximum possible confirmations
receiveLibs​```
mapping(address => mapping(uint32 => bytes32)) receiveLibs
```receive lib to call verify() on at destination
constructor​```
constructor(address _roleAdmin, address[] _admins, uint16 _defaultMultiplierBps) internal
```setReceiveLibs​```
function setReceiveLibs(struct ReceiveLibParam[] _params) external
```sets receive lib for destination chains
DEFAULT_ADMIN_ROLE can set MESSAGE_LIB_ROLE for sendLibs and use below function to set receiveLibs
_getAndAssertReceiveLib​```
function _getAndAssertReceiveLib(address _sendLib, uint32 _dstEid) internal view returns (bytes32 lib)
```_encode​```
function _encode(bytes32 _receiveLib, bytes _packetHeader, bytes32 _payloadHash) internal pure returns (bytes)
```_encodeEmpty​```
function _encodeEmpty() internal pure returns (bytes)
```_decodeAndVerify​```
function _decodeAndVerify(uint32 _srcEid, bytes _payload) internal
```_withdrawFeeFromSendLib​```
function _withdrawFeeFromSendLib(address _sendLib, address _to) internal
```_assertBalanceAndWithdrawFee​```
function _assertBalanceAndWithdrawFee(address _sendLib, uint256 _messageFee) internal
```receive​```
receive() external payable
```to receive refund
DVNAdapterMessageCodec​
DVNAdapter_InvalidMessageSize​```
error DVNAdapter_InvalidMessageSize()
```PACKET_HEADER_SIZE​```
uint256 PACKET_HEADER_SIZE
```MESSAGE_SIZE​```
uint256 MESSAGE_SIZE
```encode​```
function encode(bytes32 _receiveLib, bytes _packetHeader, bytes32 _payloadHash) internal pure returns (bytes payload)
```decode​```
function decode(bytes _message) internal pure returns (address receiveLib, bytes packetHeader, bytes32 payloadHash)
```srcEid​```
function srcEid(bytes _message) internal pure returns (uint32)
```IDVN​
DstConfigParam​```
struct DstConfigParam {  uint32 dstEid;  uint64 gas;  uint16 multiplierBps;  uint128 floorMarginUSD;}
```DstConfig​```
struct DstConfig {  uint64 gas;  uint16 multiplierBps;  uint128 floorMarginUSD;}
```SetDstConfig​```
event SetDstConfig(struct IDVN.DstConfigParam[] params)
```dstConfig​```
function dstConfig(uint32 _dstEid) external view returns (uint64, uint16, uint128)
```IDVNFeeLib​
FeeParams​```
struct FeeParams {  address priceFeed;  uint32 dstEid;  uint64 confirmations;  address sender;  uint64 quorum;  uint16 defaultMultiplierBps;}
```DVN_UnsupportedOptionType​```
error DVN_UnsupportedOptionType(uint8 optionType)
```DVN_EidNotSupported​```
error DVN_EidNotSupported(uint32 eid)
```getFeeOnSend​```
function getFeeOnSend(struct IDVNFeeLib.FeeParams _params, struct IDVN.DstConfig _dstConfig, bytes _options) external payable returns (uint256 fee)
```getFee​```
function getFee(struct IDVNFeeLib.FeeParams _params, struct IDVN.DstConfig _dstConfig, bytes _options) external view returns (uint256 fee)
```ILayerZeroDVN​
AssignJobParam​```
struct AssignJobParam {  uint32 dstEid;  bytes packetHeader;  bytes32 payloadHash;  uint64 confirmations;  address sender;}
```assignJob​```
function assignJob(struct ILayerZeroDVN.AssignJobParam _param, bytes _options) external payable returns (uint256 fee)
```getFee​```
function getFee(uint32 _dstEid, uint64 _confirmations, address _sender, bytes _options) external view returns (uint256 fee)
```IReceiveUlnE2​
should be implemented by the ReceiveUln302 contract and future ReceiveUln contracts on EndpointV2
verify​```
function verify(bytes _packetHeader, bytes32 _payloadHash, uint64 _confirmations) external
```for each dvn to verify the payload
this function signature 0x0223536e
commitVerification​```
function commitVerification(bytes _packetHeader, bytes32 _payloadHash) external
```verify the payload at endpoint, will check if all DVNs verified
DVNOptions​
WORKER_ID​```
uint8 WORKER_ID
```OPTION_TYPE_PRECRIME​```
uint8 OPTION_TYPE_PRECRIME
```DVN_InvalidDVNIdx​```
error DVN_InvalidDVNIdx()
```DVN_InvalidDVNOptions​```
error DVN_InvalidDVNOptions(uint256 cursor)
```groupDVNOptionsByIdx​```
function groupDVNOptionsByIdx(bytes _options) internal pure returns (bytes[] dvnOptions, uint8[] dvnIndices)
```group dvn options by its idx
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_options | bytes | [dvn_id][dvn_option][dvn_id][dvn_option]... dvn_option = [option_size][dvn_idx][option_type][option] option_size = len(dvn_idx) + len(option_type) + len(option) dvn_id: uint8, dvn_idx: uint8, option_size: uint16, option_type: uint8, option: bytes
--- End Table ---Return Values​--- Table ---
Name | Type | Description
--- | --- | ---
dvnOptions | bytes[] | the grouped options, still share the same format of _options
dvnIndices | uint8[] | the dvn indices
--- End Table ---_insertDVNOptions​```
function _insertDVNOptions(bytes[] _dvnOptions, uint8[] _dvnIndices, uint8 _dvnIdx, bytes _newOptions) internal pure
```getNumDVNs​```
function getNumDVNs(bytes _options) internal pure returns (uint8 numDVNs)
```get the number of unique dvns
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_options | bytes | the format is the same as groupDVNOptionsByIdx
--- End Table ---nextDVNOption​```
function nextDVNOption(bytes _options, uint256 _cursor) internal pure returns (uint8 optionType, bytes option, uint256 cursor)
```decode the next dvn option from _options starting from the specified cursor
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_options | bytes | the format is the same as groupDVNOptionsByIdx
_cursor | uint256 | the cursor to start decoding
--- End Table ---Return Values​--- Table ---
Name | Type | Description
--- | --- | ---
optionType | uint8 | the type of the option
option | bytes | the option
cursor | uint256 | the cursor to start decoding the next option
--- End Table ---UlnOptions​
TYPE_1​```
uint16 TYPE_1
```TYPE_2​```
uint16 TYPE_2
```TYPE_3​```
uint16 TYPE_3
```LZ_ULN_InvalidWorkerOptions​```
error LZ_ULN_InvalidWorkerOptions(uint256 cursor)
```LZ_ULN_InvalidWorkerId​```
error LZ_ULN_InvalidWorkerId(uint8 workerId)
```LZ_ULN_InvalidLegacyType1Option​```
error LZ_ULN_InvalidLegacyType1Option()
```LZ_ULN_InvalidLegacyType2Option​```
error LZ_ULN_InvalidLegacyType2Option()
```LZ_ULN_UnsupportedOptionType​```
error LZ_ULN_UnsupportedOptionType(uint16 optionType)
```decode​```
function decode(bytes _options) internal pure returns (bytes executorOptions, bytes dvnOptions)
```decode the options into executorOptions and dvnOptions
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_options | bytes | the options can be either legacy options (type 1 or 2) or type 3 options
--- End Table ---Return Values​--- Table ---
Name | Type | Description
--- | --- | ---
executorOptions | bytes | the executor options, share the same format of type 3 options
dvnOptions | bytes | the dvn options, share the same format of type 3 options
--- End Table ---decodeLegacyOptions​```
function decodeLegacyOptions(uint16 _optionType, bytes _options) internal pure returns (bytes executorOptions)
```decode the legacy options (type 1 or 2) into executorOptions
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_optionType | uint16 | the legacy option type
_options | bytes | the legacy options, which still has the option type in the first 2 bytes
--- End Table ---Return Values​--- Table ---
Name | Type | Description
--- | --- | ---
executorOptions | bytes | the executor options, share the same format of type 3 options Data format: legacy type 1: [extraGas] legacy type 2: [extraGas][dstNativeAmt][dstNativeAddress] extraGas: uint256, dstNativeAmt: uint256, dstNativeAddress: bytes
--- End Table ---AddressSizeConfig​
addressSizes​```
mapping(uint32 => uint256) addressSizes
```AddressSizeSet​```
event AddressSizeSet(uint16 eid, uint256 size)
```AddressSizeConfig_InvalidAddressSize​```
error AddressSizeConfig_InvalidAddressSize()
```AddressSizeConfig_AddressSizeAlreadySet​```
error AddressSizeConfig_AddressSizeAlreadySet()
```setAddressSize​```
function setAddressSize(uint16 _eid, uint256 _size) external
```ILayerZeroReceiveLibrary​
setConfig​```
function setConfig(uint16 _chainId, address _userApplication, uint256 _configType, bytes _config) external
```getConfig​```
function getConfig(uint16 _chainId, address _userApplication, uint256 _configType) external view returns (bytes)
```SetDefaultExecutorParam​```
struct SetDefaultExecutorParam {  uint32 eid;  address executor;}
```ReceiveLibBaseE1​
receive-side message library base contract on endpoint v1.
design:
1/ it provides an internal execute function that calls the endpoint. It enforces the path definition on V1.
2/ it provides interfaces to configure executors that is whitelisted to execute the msg to prevent grieving
executors​```
mapping(address => mapping(uint32 => address)) executors
```defaultExecutors​```
mapping(uint32 => address) defaultExecutors
```PacketDelivered​```
event PacketDelivered(struct Origin origin, address receiver)
```InvalidDst​```
event InvalidDst(uint16 srcChainId, bytes32 srcAddress, address dstAddress, uint64 nonce, bytes32 payloadHash)
```DefaultExecutorsSet​```
event DefaultExecutorsSet(struct SetDefaultExecutorParam[] params)
```ExecutorSet​```
event ExecutorSet(address oapp, uint32 eid, address executor)
```LZ_MessageLib_InvalidExecutor​```
error LZ_MessageLib_InvalidExecutor()
```LZ_MessageLib_OnlyExecutor​```
error LZ_MessageLib_OnlyExecutor()
```constructor​```
constructor(address _endpoint, uint32 _localEid) internal
```setDefaultExecutors​```
function setDefaultExecutors(struct SetDefaultExecutorParam[] _params) external
```getExecutor​```
function getExecutor(address _oapp, uint32 _remoteEid) public view returns (address)
```_setExecutor​```
function _setExecutor(uint32 _remoteEid, address _oapp, address _executor) internal
```_execute​```
function _execute(uint16 _srcEid, bytes32 _sender, address _receiver, uint64 _nonce, bytes _message, uint256 _gasLimit) internal
```this function change pack the path as required for EndpointV1
ReceiveUln301​
ULN301 will be deployed on EndpointV1 and is for backward compatibility with ULN302 on EndpointV2. 301 can talk to both 301 and 302
This is a gluing contract. It simply parses the requests and forward to the super.impl() accordingly.
In this case, it combines the logic of ReceiveUlnBase and ReceiveLibBaseE1
CONFIG_TYPE_EXECUTOR​```
uint256 CONFIG_TYPE_EXECUTOR
```CONFIG_TYPE_ULN​```
uint256 CONFIG_TYPE_ULN
```LZ_ULN_InvalidConfigType​```
error LZ_ULN_InvalidConfigType(uint256 configType)
```constructor​```
constructor(address _endpoint, uint32 _localEid) public
```setConfig​```
function setConfig(uint16 _eid, address _oapp, uint256 _configType, bytes _config) external
```commitVerification​```
function commitVerification(bytes _packet, uint256 _gasLimit) external
```in 301, this is equivalent to execution as in Endpoint V2
dont need to check endpoint verifiable here to save gas, as it will reverts if not verifiable.
verify​```
function verify(bytes _packetHeader, bytes32 _payloadHash, uint64 _confirmations) external
```getConfig​```
function getConfig(uint16 _eid, address _oapp, uint256 _configType) external view returns (bytes)
```version​```
function version() external pure returns (uint64 major, uint8 minor, uint8 endpointVersion)
```VerificationState​```
enum VerificationState {  Verifying,  Verifiable,  Verified}
```IReceiveUln301​
assertHeader​```
function assertHeader(bytes _packetHeader, uint32 _localEid) external pure
```addressSizes​```
function addressSizes(uint32 _dstEid) external view returns (uint256)
```endpoint​```
function endpoint() external view returns (address)
```verifiable​```
function verifiable(struct UlnConfig _config, bytes32 _headerHash, bytes32 _payloadHash) external view returns (bool)
```getUlnConfig​```
function getUlnConfig(address _oapp, uint32 _remoteEid) external view returns (struct UlnConfig rtnConfig)
```ReceiveUln301View​
endpoint​```
contract ILayerZeroEndpoint endpoint
```receiveUln301​```
contract IReceiveUln301 receiveUln301
```localEid​```
uint32 localEid
```initialize​```
function initialize(address _endpoint, uint32 _localEid, address _receiveUln301) external
```executable​```
function executable(bytes _packetHeader, bytes32 _payloadHash) public view returns (enum ExecutionState)
```verifiable​```
function verifiable(bytes _packetHeader, bytes32 _payloadHash) external view returns (enum VerificationState)
```keeping the same interface as 302
a verifiable message requires it to be ULN verifiable only, excluding the endpoint verifiable check
SendLibBaseE1​
send-side message library base contract on endpoint v1.
design:
1/ it enforces the path definition on V1 and interacts with the nonce contract
2/ quote: first executor, then verifier (e.g. DVNs), then treasury
3/ send: first executor, then verifier (e.g. DVNs), then treasury. the treasury pay much be DoS-proof
nonceContract​```
contract INonceContract nonceContract
```treasuryFeeHandler​```
contract ITreasuryFeeHandler treasuryFeeHandler
```lzToken​```
address lzToken
```PacketSent​```
event PacketSent(bytes encodedPayload, bytes options, uint256 nativeFee, uint256 lzTokenFee)
```NativeFeeWithdrawn​```
event NativeFeeWithdrawn(address user, address receiver, uint256 amount)
```LzTokenSet​```
event LzTokenSet(address token)
```constructor​```
constructor(address _endpoint, uint256 _treasuryGasLimit, uint256 _treasuryNativeFeeCap, address _nonceContract, uint32 _localEid, address _treasuryFeeHandler) internal
```send​```
function send(address _sender, uint64, uint16 _dstEid, bytes _path, bytes _message, address payable _refundAddress, address _lzTokenPaymentAddress, bytes _options) external payable
```the abstract process for send() is:
1/ pay workers, which includes the executor and the validation workers
2/ pay treasury
3/ in EndpointV1, here we handle the fees and refunds
setLzToken​```
function setLzToken(address _lzToken) external
```setTreasury​```
function setTreasury(address _treasury) external
```withdrawFee​```
function withdrawFee(address _to, uint256 _amount) external
```estimateFees​```
function estimateFees(uint16 _dstEid, address _sender, bytes _message, bool _payInLzToken, bytes _options) external view returns (uint256 nativeFee, uint256 lzTokenFee)
```_assertPath​```
function _assertPath(address _sender, bytes _path, uint256 remoteAddressSize) internal pure
```path = remoteAddress + localAddress.
_payLzTokenFee​```
function _payLzTokenFee(address _sender, uint256 _lzTokenFee) internal
```_outbound​```
function _outbound(address _sender, uint16 _dstEid, bytes _path, bytes _message) internal returns (struct Packet packet)
```_outbound does three things1. asserts path
2. increments the nonce
3. assemble packet_Return Values​--- Table ---
Name | Type | Description
--- | --- | ---
packet | struct Packet | to be sent to workers
--- End Table ---_payWorkers​```
function _payWorkers(address _sender, uint16 _dstEid, bytes _path, bytes _message, bytes _options) internal returns (bytes encodedPacket, uint256 totalNativeFee)
```1/ handle executor
2/ handle other workers
_payVerifier​```
function _payVerifier(struct Packet _packet, struct WorkerOptions[] _options) internal virtual returns (uint256 otherWorkerFees, bytes encodedPacket)
```SendUln301​
ULN301 will be deployed on EndpointV1 and is for backward compatibility with ULN302 on EndpointV2. 301 can talk to both 301 and 302
This is a gluing contract. It simply parses the requests and forward to the super.impl() accordingly.
In this case, it combines the logic of SendUlnBase and SendLibBaseE1
CONFIG_TYPE_EXECUTOR​```
uint256 CONFIG_TYPE_EXECUTOR
```CONFIG_TYPE_ULN​```
uint256 CONFIG_TYPE_ULN
```LZ_ULN_InvalidConfigType​```
error LZ_ULN_InvalidConfigType(uint256 configType)
```constructor​```
constructor(address _endpoint, uint256 _treasuryGasLimit, uint256 _treasuryGasForFeeCap, address _nonceContract, uint32 _localEid, address _treasuryFeeHandler) public
```setConfig​```
function setConfig(uint16 _eid, address _oapp, uint256 _configType, bytes _config) external
```getConfig​```
function getConfig(uint16 _eid, address _oapp, uint256 _configType) external view returns (bytes)
```version​```
function version() external pure returns (uint64 major, uint8 minor, uint8 endpointVersion)
```isSupportedEid​```
function isSupportedEid(uint32 _eid) external view returns (bool)
```_quoteVerifier​```
function _quoteVerifier(address _sender, uint32 _dstEid, struct WorkerOptions[] _options) internal view returns (uint256)
```_payVerifier​```
function _payVerifier(struct Packet _packet, struct WorkerOptions[] _options) internal virtual returns (uint256 otherWorkerFees, bytes encodedPacket)
```_splitOptions​```
function _splitOptions(bytes _options) internal pure returns (bytes, struct WorkerOptions[])
```this function will split the options into executorOptions and validationOptions
TreasuryFeeHandler​
endpoint​```
contract ILayerZeroEndpoint endpoint
```LZ_TreasuryFeeHandler_OnlySendLibrary​```
error LZ_TreasuryFeeHandler_OnlySendLibrary()
```LZ_TreasuryFeeHandler_OnlyOnSending​```
error LZ_TreasuryFeeHandler_OnlyOnSending()
```LZ_TreasuryFeeHandler_InvalidAmount​```
error LZ_TreasuryFeeHandler_InvalidAmount(uint256 required, uint256 supplied)
```constructor​```
constructor(address _endpoint) public
```payFee​```
function payFee(address _lzToken, address _sender, uint256 _required, uint256 _supplied, address _treasury) external
```IMessageLibE1​
extends ILayerZeroMessagingLibrary instead of ILayerZeroMessagingLibraryV2 for reducing the contract size
LZ_MessageLib_InvalidPath​```
error LZ_MessageLib_InvalidPath()
```LZ_MessageLib_InvalidSender​```
error LZ_MessageLib_InvalidSender()
```LZ_MessageLib_InsufficientMsgValue​```
error LZ_MessageLib_InsufficientMsgValue()
```LZ_MessageLib_LzTokenPaymentAddressMustBeSender​```
error LZ_MessageLib_LzTokenPaymentAddressMustBeSender()
```setLzToken​```
function setLzToken(address _lzToken) external
```setTreasury​```
function setTreasury(address _treasury) external
```withdrawFee​```
function withdrawFee(address _to, uint256 _amount) external
```version​```
function version() external view returns (uint64 major, uint8 minor, uint8 endpointVersion)
```INonceContract​
increment​```
function increment(uint16 _chainId, address _ua, bytes _path) external returns (uint64)
```ITreasuryFeeHandler​
payFee​```
function payFee(address _lzToken, address _sender, uint256 _required, uint256 _supplied, address _treasury) external
```IUltraLightNode301​
commitVerification​```
function commitVerification(bytes _packet, uint256 _gasLimit) external
```NonceContractMock​
OnlySendLibrary​```
error OnlySendLibrary()
```endpoint​```
contract ILayerZeroEndpoint endpoint
```outboundNonce​```
mapping(uint16 => mapping(bytes => uint64)) outboundNonce
```constructor​```
constructor(address _endpoint) public
```increment​```
function increment(uint16 _chainId, address _ua, bytes _path) external returns (uint64)
```ReceiveUln302​
This is a gluing contract. It simply parses the requests and forward to the super.impl() accordingly.
In this case, it combines the logic of ReceiveUlnBase and ReceiveLibBaseE2
CONFIG_TYPE_ULN​```
uint32 CONFIG_TYPE_ULN
```CONFIG_TYPE_ULN=2 here to align with SendUln302/ReceiveUln302/ReceiveUln301
LZ_ULN_InvalidConfigType​```
error LZ_ULN_InvalidConfigType(uint32 configType)
```constructor​```
constructor(address _endpoint) public
```supportsInterface​```
function supportsInterface(bytes4 _interfaceId) public view returns (bool)
```setConfig​```
function setConfig(address _oapp, struct SetConfigParam[] _params) external
```commitVerification​```
function commitVerification(bytes _packetHeader, bytes32 _payloadHash) external
```dont need to check endpoint verifiable here to save gas, as it will reverts if not verifiable.
verify​```
function verify(bytes _packetHeader, bytes32 _payloadHash, uint64 _confirmations) external
```for dvn to verify the payload
getConfig​```
function getConfig(uint32 _eid, address _oapp, uint32 _configType) external view returns (bytes)
```isSupportedEid​```
function isSupportedEid(uint32 _eid) external view returns (bool)
```version​```
function version() external pure returns (uint64 major, uint8 minor, uint8 endpointVersion)
```VerificationState​```
enum VerificationState {  Verifying,  Verifiable,  Verified,  NotInitializable}
```IReceiveUln302​
assertHeader​```
function assertHeader(bytes _packetHeader, uint32 _localEid) external pure
```verifiable​```
function verifiable(struct UlnConfig _config, bytes32 _headerHash, bytes32 _payloadHash) external view returns (bool)
```getUlnConfig​```
function getUlnConfig(address _oapp, uint32 _remoteEid) external view returns (struct UlnConfig rtnConfig)
```ReceiveUln302View​
receiveUln302​```
contract IReceiveUln302 receiveUln302
```localEid​```
uint32 localEid
```initialize​```
function initialize(address _endpoint, address _receiveUln302) external
```verifiable​```
function verifiable(bytes _packetHeader, bytes32 _payloadHash) external view returns (enum VerificationState)
```a ULN verifiable requires it to be endpoint verifiable and committable
_endpointVerifiable​```
function _endpointVerifiable(struct Origin origin, address _receiver, bytes32 _payloadHash) internal view returns (bool)
```checks for endpoint verifiable and endpoint has payload hash
SendUln302​
This is a gluing contract. It simply parses the requests and forward to the super.impl() accordingly.
In this case, it combines the logic of SendUlnBase and SendLibBaseE2
CONFIG_TYPE_EXECUTOR​```
uint32 CONFIG_TYPE_EXECUTOR
```CONFIG_TYPE_ULN​```
uint32 CONFIG_TYPE_ULN
```LZ_ULN_InvalidConfigType​```
error LZ_ULN_InvalidConfigType(uint32 configType)
```constructor​```
constructor(address _endpoint, uint256 _treasuryGasLimit, uint256 _treasuryGasForFeeCap) public
```setConfig​```
function setConfig(address _oapp, struct SetConfigParam[] _params) external
```getConfig​```
function getConfig(uint32 _eid, address _oapp, uint32 _configType) external view returns (bytes)
```version​```
function version() external pure returns (uint64 major, uint8 minor, uint8 endpointVersion)
```isSupportedEid​```
function isSupportedEid(uint32 _eid) external view returns (bool)
```_quoteVerifier​```
function _quoteVerifier(address _sender, uint32 _dstEid, struct WorkerOptions[] _options) internal view returns (uint256)
```_payVerifier​```
function _payVerifier(struct Packet _packet, struct WorkerOptions[] _options) internal returns (uint256 otherWorkerFees, bytes encodedPacket)
```_splitOptions​```
function _splitOptions(bytes _options) internal pure returns (bytes, struct WorkerOptions[])
```this function will split the options into executorOptions and validationOptions
WorkerUpgradeable​
MESSAGE_LIB_ROLE​```
bytes32 MESSAGE_LIB_ROLE
```ALLOWLIST​```
bytes32 ALLOWLIST
```DENYLIST​```
bytes32 DENYLIST
```ADMIN_ROLE​```
bytes32 ADMIN_ROLE
```workerFeeLib​```
address workerFeeLib
```allowlistSize​```
uint64 allowlistSize
```defaultMultiplierBps​```
uint16 defaultMultiplierBps
```priceFeed​```
address priceFeed
```supportedOptionTypes​```
mapping(uint32 => uint8[]) supportedOptionTypes
```__Worker_init​```
function __Worker_init(address[] _messageLibs, address _priceFeed, uint16 _defaultMultiplierBps, address _roleAdmin, address[] _admins) internal
```Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_messageLibs | address[] | array of message lib addresses that are granted the MESSAGE_LIB_ROLE
_priceFeed | address | price feed address
_defaultMultiplierBps | uint16 | default multiplier for worker fee
_roleAdmin | address | address that is granted the DEFAULT_ADMIN_ROLE (can grant and revoke all roles)
_admins | address[] | array of admin addresses that are granted the ADMIN_ROLE
--- End Table ---__Worker_init_unchained​```
function __Worker_init_unchained(address[] _messageLibs, address _priceFeed, uint16 _defaultMultiplierBps, address _roleAdmin, address[] _admins) internal
```onlyAcl​```
modifier onlyAcl(address _sender)
```hasAcl​```
function hasAcl(address _sender) public view returns (bool)
```_Access control list using allowlist and denylist1. if one address is in the denylist -> deny
2. else if address in the allowlist OR allowlist is empty (allows everyone)-> allow
3. else deny_Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_sender | address | address to check
--- End Table ---setPaused​```
function setPaused(bool _paused) external
```flag to pause execution of workers (if used with whenNotPaused modifier)
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_paused | bool | true to pause, false to unpause
--- End Table ---setPriceFeed​```
function setPriceFeed(address _priceFeed) external
```Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_priceFeed | address | price feed address
--- End Table ---setWorkerFeeLib​```
function setWorkerFeeLib(address _workerFeeLib) external
```Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_workerFeeLib | address | worker fee lib address
--- End Table ---setDefaultMultiplierBps​```
function setDefaultMultiplierBps(uint16 _multiplierBps) external
```Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_multiplierBps | uint16 | default multiplier for worker fee
--- End Table ---withdrawFee​```
function withdrawFee(address _lib, address _to, uint256 _amount) external
```supports withdrawing fee from ULN301, ULN302 and more
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_lib | address | message lib address
_to | address | address to withdraw fee to
_amount | uint256 | amount to withdraw
--- End Table ---withdrawToken​```
function withdrawToken(address _token, address _to, uint256 _amount) external
```supports withdrawing token from the contract
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_token | address | token address
_to | address | address to withdraw token to
_amount | uint256 | amount to withdraw
--- End Table ---setSupportedOptionTypes​```
function setSupportedOptionTypes(uint32 _eid, uint8[] _optionTypes) external
```getSupportedOptionTypes​```
function getSupportedOptionTypes(uint32 _eid) external view returns (uint8[])
```_grantRole​```
function _grantRole(bytes32 _role, address _account) internal
```overrides AccessControl to allow for counting of allowlistSize
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_role | bytes32 | role to grant
_account | address | address to grant role to
--- End Table ---_revokeRole​```
function _revokeRole(bytes32 _role, address _account) internal
```overrides AccessControl to allow for counting of allowlistSize
Parameters​--- Table ---
Name | Type | Description
--- | --- | ---
_role | bytes32 | role to revoke
_account | address | address to revoke role from
--- End Table ---renounceRole​```
function renounceRole(bytes32, address) public pure
```overrides AccessControl to disable renouncing of roles

---
Note: This content was extracted from the LayerZero documentation. Tables and special components have been converted to plain text for better readability.
