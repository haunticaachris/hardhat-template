// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Interface for EIP20 https://eips.ethereum.org/EIPS/eip-20
interface IERC20 {
    // Triggered on a successful call to approve.
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Triggered when tokens are transferred or when new tokens are created.
    // When new tokens are created it should trigger with the from address set to 0x0.
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Returns the amount spender is allowed to transfer from owner.
    function allowance(address owner, address spender) external view returns (uint256 remaining);

    // Approves spender to make several transfers from an account up to value amount.
    // Overwrites current allowance with value if called again.
    // WARNING: Possible front running attack
    function approve(address spender, uint256 value) external returns (bool success);

    // Returns balance of owner
    function balanceOf(address owner) external view returns (uint256 balance);

    // Returns total token supply
    function totalSupply() external view returns (uint256 total);

    // Transfers value amount to address and triggers a Transfer event.
    // Should throw if caller does not have enough tokens
    function transfer(address to, uint256 value) external returns (bool success);

    // Transfers value amount from from to the address to and fires a Transfer event.
    // Should throw if from does not have enough tokens or the caller is not authorized.
    // Transfers of value 0 MUST be treated as normal.
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool success);
}
