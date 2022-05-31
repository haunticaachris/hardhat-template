// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../implementations/ERC173.sol";
import "../implementations/ERC721Enumerable.sol";
import "../implementations/ERC721Metadata.sol";

contract ERC721Test is ERC173, ERC721Enumerable, ERC721Metadata {
    constructor(string memory name_, string memory symbol_) ERC721Metadata(name_, symbol_) {
        ERC721._mint(msg.sender, 0);
    }

    function burn(uint256 tokenId_) public virtual {
        address owner = ERC721.ownerOf(tokenId_);

        require(owner == msg.sender || ERC721.isApprovedForAll(owner, msg.sender), "ERC721: unauthorized");

        ERC721._burn(tokenId_);
    }

    function burnOwner(uint256 tokenId_) public virtual onlyOwner {
        ERC721._burn(tokenId_);
    }

    function internalApprove(
        address owner_,
        address approved_,
        uint256 tokenId_
    ) public virtual onlyOwner {
        ERC721._approve(owner_, approved_, tokenId_);
    }

    function mint(address to_, uint256 tokenId_) public virtual onlyOwner {
        ERC721._mint(to_, tokenId_);
    }

    function setTokenURI(uint256 tokenId_, string memory value_) public virtual onlyOwner {
        ERC721.ownerOf(tokenId_);

        ERC721Metadata._setTokenURI(tokenId_, value_);
    }

    function _onTransfer(
        address from_,
        address to_,
        uint256 tokenId_
    ) internal virtual override(ERC721, ERC721Enumerable) {
        ERC721Enumerable._onTransfer(from_, to_, tokenId_);
    }
}
