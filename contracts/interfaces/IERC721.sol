// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC165.sol";

// Interface for ERC-721 https://eips.ethereum.org/EIPS/eip-721
// Implementations should also implement ERC165 https://eips.ethereum.org/EIPS/eip-165
// The ERC-165 ID for this interface is 0x80ac58cd
// Implementations may also throw in other situations not specified
// and tokenIds may not have a specific pattern. Mint and burn functions
// are not specified but must emit a Transfer event except at contract creation.
interface IERC721 is IERC165 {
    // Triggered when the approved address is updated. The zero address
    // means there is no approved address and if a transfer event is
    // triggered the approved address is reset back to none.
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    // Triggered when an operator is approved or disabled.
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    // Triggered when any token transfers ownership.
    // When from or to is the zero address it means a token
    // was created or destroyed. When a contract is created,
    // any number of tokens may be created or assigned without
    // triggering this event. When this event emits the approved
    // address for tokenId is also reset.
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    // Updates the approved address or resets it to the zero address
    // meaning there is no approved address and throws if the
    // sender is not the owner or an operator address. Triggers
    // the Approval event.
    function approve(address approved, uint256 tokenId) external payable;

    // Returns the number of tokens owned by an address and
    // throws if the owner address is the zero address (invalid tokens).
    function balanceOf(address owner) external view returns (uint256 balance);

    // Returns the approved address for a token or
    // the zero address if there is none.
    // Throws if the token is invalid.
    function getApproved(uint256 tokenId) external view returns (address approved);

    // Returns true if an address is an authorized operator
    // for owner.
    function isApprovedForAll(address owner, address operator) external view returns (bool approved);

    // Returns the owner of a token and throws if it's owned
    // by the zero address (invalid token).
    function ownerOf(uint256 tokenId) external view returns (address owner);

    // Transfers the ownership of a token and works just like the other function
    // with the data parameter but sets data to "".
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external payable;

    // Transfers the ownership of a token and throws if the sender is not the owner,
    // an operator, or an approved address, from is not the current owner, to is
    // the zero address, the tokenId is invalid, or to is a smart contract and
    // the value of onERC721Received called on it is not  equal to
    // the magic value.
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) external payable;

    // Enable or disable approval for an operator to manage all
    // of the senders tokens and triggers ApprovalForAll. The
    // implementation must allow for multiple authorized operators.
    function setApprovalForAll(address operator, bool approved) external;

    // Transfers the ownership of a token without checking if
    // to is able to receive a token. Tokens may be lost if
    // to is unable to handle tokens. Reverts for the same reasons
    // as safeTransferFrom.
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external payable;
}
