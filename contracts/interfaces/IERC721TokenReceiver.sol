// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC165.sol";

// Interface for IERC721TokenReceiver https://eips.ethereum.org/EIPS/eip-721
// Implementations should also implement ERC165 https://eips.ethereum.org/EIPS/eip-165
// The ERC-165 ID for this interface is 0x150b7a02
interface IERC721TokenReceiver is IERC165 {
    // This is called by an ERC721 smart contract after a safe transfer
    // in order to handle the received token. This function may throw to
    // reject / revert a transfer and must return the value of
    // bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))
    // or the transfer will be reverted. The magic number value will always be
    // 0x150b7a02.
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4 value);
}
