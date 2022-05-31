// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IERC165.sol";

abstract contract ERC165 is IERC165 {
    mapping(bytes4 => bool) internal _supportsInterface;

    constructor() {
        _supportsInterface[type(IERC165).interfaceId] = true;
    }

    function supportsInterface(bytes4 interfaceID_) public view virtual override returns (bool) {
        return _supportsInterface[interfaceID_];
    }
}
