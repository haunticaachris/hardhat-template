// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Interface for ERC165 https://eips.ethereum.org/EIPS/eip-165
// The ERC-165 ID for this interface is 0x01ffc9a7
interface IERC165 {
    // Detects what interfaces a smart contract supports
    // This will return true when interfaceID is 0x01ffc9a7 (EIP165) or
    // any interfaceID this contract implements. This will return false
    // for 0xffffffff any other interfaceID not implemented. This function
    // should use less than 30,000 gas.
    function supportsInterface(bytes4 interfaceID) external view returns (bool supported);
}
