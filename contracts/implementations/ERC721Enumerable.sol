// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "../interfaces/IERC721Enumerable.sol";

abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
    mapping(address => uint256[]) private _ownerTokens;
    mapping(uint256 => uint256) private _ownerTokenIds;
    mapping(uint256 => uint256) private _tokenIds;
    uint256[] private _tokens;

    constructor() {
        _supportsInterface[type(IERC721Enumerable).interfaceId] = true;
    }

    function tokenByIndex(uint256 index_) public view virtual override returns (uint256) {
        require(index_ < _tokens.length, "ERC721: invalid token");

        return _tokens[index_];
    }

    function tokenOfOwnerByIndex(address owner_, uint256 index_) public view virtual override returns (uint256) {
        require(owner_ != address(0), "ERC721: invalid token");
        require(index_ < _ownerTokens[owner_].length, "ERC721: invalid token");

        return _ownerTokens[owner_][index_];
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _tokens.length;
    }

    function _onTransfer(
        address from_,
        address to_,
        uint256 tokenId_
    ) internal virtual override(ERC721) {
        if (from_ != address(0)) {
            uint256 index = _ownerTokenIds[tokenId_];
            uint256 last = _ownerTokens[from_][_ownerTokens[from_].length - 1];

            _ownerTokens[from_][index] = last;
            _ownerTokenIds[last] = index;
            _ownerTokenIds[tokenId_] = 0;

            _ownerTokens[from_].pop();
        } else {
            _tokenIds[tokenId_] = _tokens.length;

            _tokens.push(tokenId_);
        }

        if (to_ != address(0)) {
            _ownerTokenIds[tokenId_] = _ownerTokens[to_].length;

            _ownerTokens[to_].push(tokenId_);
        } else {
            uint256 index = _tokenIds[tokenId_];
            uint256 last = _tokens[_tokens.length - 1];

            _tokens[index] = last;
            _tokenIds[last] = index;
            _tokenIds[tokenId_] = 0;

            _tokens.pop();
        }

        ERC721._onTransfer(from_, to_, tokenId_);
    }
}
