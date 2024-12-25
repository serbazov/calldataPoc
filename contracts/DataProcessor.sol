// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";
import "./UnsafeCalldataBytesLib.sol";

contract DataProcessor {
    uint256 internal constant STANDARD_SLOT_BS = 32;
    bytes32 public storedData;

    function processData(uint256 timestamp) external {
        bytes32 messageEncoded;
        assembly {
            messageEncoded := calldataload(
                sub(calldatasize(), STANDARD_SLOT_BS)
            )
        }
        storedData = messageEncoded;
    }
    function processDataExplicit(
        uint256 timestamp,
        bytes calldata _calldata
    ) external {
        bytes32 messageEncoded = UnsafeCalldataBytesLib.toBytes32(_calldata, 0);
        storedData = messageEncoded;
    }
}
