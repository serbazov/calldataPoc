// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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
}
