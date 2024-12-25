// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";
import "./UnsafeCalldataBytesLib.sol";

contract DataProcessor {
    bytes32 public storedData;

    function processData(uint256 timestamp) external {
        uint256 payloadOffset = 0x04 + 0x20; // 4 bytes for selector, 32 bytes for timestamp

        require(msg.data.length >= payloadOffset + 32, "Payload too short");
        bytes32 messageEncoded;

        assembly {
            messageEncoded := calldataload(payloadOffset)
        }
        storedData = messageEncoded;
    }
    function processDataExplicit(bytes calldata _calldata) external {
        uint256 _timestamp = UnsafeCalldataBytesLib.toUint256(_calldata, 0);
        bytes32 messageEncoded = UnsafeCalldataBytesLib.toBytes32(
            _calldata,
            32
        );
        storedData = messageEncoded;
    }
}
