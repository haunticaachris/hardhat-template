// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC165.sol";

// Interface for ERC173 https://eips.ethereum.org/EIPS/eip-173
// Should also implement ERC165 https://eips.ethereum.org/EIPS/eip-165
// The ERC-165 ID for this interface is 0x7f5828d0
interface IERC173 is IERC165 {
    // Triggered when the owner of a contract changes.
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // Returns the contracts owner
    function owner() external view returns (address owner);

    // Transfer ownership of the contract to newOwner. Set newOwner to the
    // zero address to renounce any ownership.
    function transferOwnership(address newOwner) external;
}
