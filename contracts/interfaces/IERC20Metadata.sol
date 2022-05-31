// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

// Interface for optional metadata methods https://eips.ethereum.org/EIPS/eip-20
interface IERC20Metadata is IERC20 {
    // Returns the number of decimals used by the token
    function decimals() external view returns (uint8 decimals);

    // Returns the name of the token
    function name() external view returns (string memory name);

    // Returns the symbol of the token
    function symbol() external view returns (string memory symbol);
}
