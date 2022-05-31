// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721.sol";

// Interface for ERC721 Metadata extension https://eips.ethereum.org/EIPS/eip-721
// Implementations should also implement ERC721 https://eips.ethereum.org/EIPS/eip-721
// Implementations should also implement ERC165 https://eips.ethereum.org/EIPS/eip-165
// The ERC-165 ID for this interface is 0x5b5e139f
interface IERC721Metadata is IERC721 {
    // Returns the name of the token collection and may be empty.
    function name() external view returns (string memory name);

    // Returns the symbol of the token collection and may be empty.
    function symbol() external view returns (string memory symbol);

    // Returns the URI (RFC 3986) for a specific token and throws if it is not
    // a valid token. The URI may point to a valid file following the
    // ERC721 Metadata JSON Schema. The URI may change at any time.
    function tokenURI(uint256 tokenId) external view returns (string memory uri);
}
