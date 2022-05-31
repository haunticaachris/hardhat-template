// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol";
import "../interfaces/IERC173.sol";

abstract contract ERC173 is ERC165, IERC173 {
    address private _owner;

    modifier onlyOwner() {
        require(_owner == msg.sender, "ERC173: unauthorized");
        _;
    }

    constructor() {
        _owner = msg.sender;

        _supportsInterface[type(IERC173).interfaceId] = true;

        emit OwnershipTransferred(address(0), msg.sender);
    }

    function owner() public view virtual override returns (address) {
        return _owner;
    }

    function transferOwnership(address newOwner_) public virtual override onlyOwner {
        address previousOwner = _owner;

        _owner = newOwner_;

        emit OwnershipTransferred(previousOwner, newOwner_);
    }
}
