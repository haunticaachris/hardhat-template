// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721.sol";

// Interface for ERC721 Enumerable extension https://eips.ethereum.org/EIPS/eip-721
// Implementations should also implement ERC721 https://eips.ethereum.org/EIPS/eip-721
// Implementations should also implement ERC165 https://eips.ethereum.org/EIPS/eip-165
// The ERC-165 ID for this interface is 0x780e9d63
interface IERC721Enumerable is IERC721 {
    // Returns the tokenId of the token at index. This
    // may not be sorted in a specific order and will throw
    // if the index is greater than or equal to totalSupply().
    function tokenByIndex(uint256 index) external view returns (uint256 tokenId);

    // Returns the tokenId of the token at index for an address. This
    // may not be sorted in a specific order and will throw
    // if the index is greater than or equal to balanceOf(owner)
    // or the owner is the zero address.
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

    // Returns a count of valid ERC721 tokens with an
    // assigned owner other than the zero address.
    function totalSupply() external view returns (uint256 total);
}
