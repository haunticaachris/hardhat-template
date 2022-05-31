// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol";
import "../interfaces/IERC721.sol";
import "../interfaces/IERC721TokenReceiver.sol";

abstract contract ERC721 is ERC165, IERC721 {
    mapping(uint256 => address) private _approved;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => bool)) private _operators;
    mapping(uint256 => address) private _owners;

    constructor() {
        _supportsInterface[type(IERC721).interfaceId] = true;
    }

    function approve(address approved_, uint256 tokenId_) public payable virtual override {
        address owner = _owners[tokenId_];

        require(owner == msg.sender || _operators[owner][msg.sender], "ERC721: unauthorized");

        _approve(owner, approved_, tokenId_);
    }

    function balanceOf(address owner_) public view virtual override returns (uint256) {
        require(owner_ != address(0), "ERC721: invalid address");

        return _balances[owner_];
    }

    function getApproved(uint256 tokenId_) public view virtual override returns (address) {
        require(_owners[tokenId_] != address(0), "ERC721: invalid token");

        return _approved[tokenId_];
    }

    function isApprovedForAll(address owner_, address operator_) public view virtual override returns (bool) {
        return _operators[owner_][operator_];
    }

    function ownerOf(uint256 tokenId_) public view virtual override returns (address) {
        require(_owners[tokenId_] != address(0), "ERC721: invalid token");

        return _owners[tokenId_];
    }

    function safeTransferFrom(
        address from_,
        address to_,
        uint256 tokenId_
    ) public payable virtual override {
        transferFrom(from_, to_, tokenId_);

        _callOnERC721Received(from_, to_, tokenId_, "");
    }

    function safeTransferFrom(
        address from_,
        address to_,
        uint256 tokenId_,
        bytes memory data_
    ) public payable virtual override {
        transferFrom(from_, to_, tokenId_);

        _callOnERC721Received(from_, to_, tokenId_, data_);
    }

    function setApprovalForAll(address operator_, bool approved_) public virtual override {
        _setApprovalForAll(msg.sender, operator_, approved_);
    }

    function transferFrom(
        address from_,
        address to_,
        uint256 tokenId_
    ) public payable virtual override {
        address owner = _owners[tokenId_];

        require(owner != address(0), "ERC721: invalid token");
        require(owner == from_, "ERC721: invalid address");
        require(to_ != address(0), "ERC721: invalid address");
        require(to_ != address(this), "ERC721: invalid address");

        require(
            owner == msg.sender || _operators[owner][msg.sender] || _approved[tokenId_] == msg.sender,
            "ERC721: unauthorized"
        );

        _approved[tokenId_] = address(0);

        _balances[from_] -= 1;
        _balances[to_] += 1;
        _owners[tokenId_] = to_;

        _onTransfer(from_, to_, tokenId_);
    }

    function _approve(
        address owner_,
        address approved_,
        uint256 tokenId_
    ) internal virtual {
        require(owner_ == _owners[tokenId_], "ERC721: invalid address");

        _approved[tokenId_] = approved_;

        emit Approval(owner_, approved_, tokenId_);
    }

    function _burn(uint256 tokenId_) internal virtual {
        address owner = _owners[tokenId_];

        require(owner != address(0), "ERC721: invalid token");

        _approved[tokenId_] = address(0);

        _balances[owner] -= 1;
        _owners[tokenId_] = address(0);

        _onTransfer(owner, address(0), tokenId_);
    }

    function _callOnERC721Received(
        address from_,
        address to_,
        uint256 tokenId_,
        bytes memory data_
    ) internal virtual {
        if (to_.code.length > 0) {
            try IERC721TokenReceiver(to_).onERC721Received(msg.sender, from_, tokenId_, data_) returns (bytes4 ret) {
                require(ret == 0x150b7a02, "ERC721: onERC721Received");
            } catch {
                revert("ERC721: onERC721Received");
            }
        }
    }

    function _mint(address to_, uint256 tokenId_) internal virtual {
        require(to_ != address(0), "ERC721: invalid address");
        require(to_ != address(this), "ERC721: invalid address");
        require(_owners[tokenId_] == address(0), "ERC721: invalid token");

        _balances[to_] += 1;
        _owners[tokenId_] = to_;

        _onTransfer(address(0), to_, tokenId_);

        _callOnERC721Received(address(0), to_, tokenId_, "");
    }

    function _onTransfer(
        address from_,
        address to_,
        uint256 tokenId_
    ) internal virtual {
        emit Transfer(from_, to_, tokenId_);
    }

    function _setApprovalForAll(
        address owner_,
        address operator_,
        bool approved_
    ) internal virtual {
        _operators[owner_][operator_] = approved_;

        emit ApprovalForAll(owner_, operator_, approved_);
    }
}
