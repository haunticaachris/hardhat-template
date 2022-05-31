// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../implementations/ERC165.sol";
import "../interfaces/IERC721TokenReceiver.sol";

contract ERC721TokenReceiverTest is ERC165, IERC721TokenReceiver {
    bool private _ret;

    constructor(bool ret_) {
        _ret = ret_;

        _supportsInterface[type(IERC721TokenReceiver).interfaceId] = true;
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) public virtual override returns (bytes4 value) {
        if (_ret) {
            return 0x150b7a02;
        }

        return 0;
    }
}
