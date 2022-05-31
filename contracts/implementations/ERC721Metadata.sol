// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "../interfaces/IERC721Metadata.sol";

abstract contract ERC721Metadata is ERC721, IERC721Metadata {
    string private _name;
    string private _symbol;
    mapping(uint256 => string) private _tokenURIs;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;

        _supportsInterface[type(IERC721Metadata).interfaceId] = true;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 tokenId_) public view virtual override returns (string memory) {
        ERC721.ownerOf(tokenId_);

        return _tokenURIs[tokenId_];
    }

    function _setTokenURI(uint256 tokenId_, string memory value_) internal virtual {
        _tokenURIs[tokenId_] = value_;
    }
}
