// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IERC20.sol";

abstract contract ERC20 is IERC20 {
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => uint256) private _balances;
    uint256 private _totalSupply;

    function allowance(address owner_, address spender_) public view virtual override returns (uint256) {
        return _allowances[owner_][spender_];
    }

    function approve(address spender_, uint256 value_) public virtual override returns (bool) {
        _approve(msg.sender, spender_, value_);

        return true;
    }

    function balanceOf(address owner_) public view virtual override returns (uint256) {
        return _balances[owner_];
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function transfer(address to_, uint256 value_) public virtual override returns (bool) {
        _transfer(msg.sender, to_, value_);

        return true;
    }

    function transferFrom(
        address from_,
        address to_,
        uint256 value_
    ) public virtual override returns (bool) {
        uint256 currentAllowance = _allowances[from_][msg.sender];

        require(currentAllowance >= value_, "ERC20: insufficient allowance");

        _allowances[from_][msg.sender] = currentAllowance - value_;

        _transfer(from_, to_, value_);

        return true;
    }

    function _approve(
        address owner_,
        address spender_,
        uint256 value_
    ) internal virtual {
        _allowances[owner_][spender_] = value_;

        emit Approval(owner_, spender_, value_);
    }

    function _burn(address from_, uint256 value_) internal virtual {
        uint256 balance = _balances[from_];

        require(balance >= value_, "ERC20: insufficient balance");

        _balances[from_] = balance - value_;
        _totalSupply -= value_;

        _onTransfer(from_, address(0), value_);
    }

    function _mint(address to_, uint256 value_) internal virtual {
        require(to_ != address(0), "ERC20: invalid address");

        _balances[to_] += value_;
        _totalSupply += value_;

        _onTransfer(address(0), to_, value_);
    }

    function _onTransfer(
        address from_,
        address to_,
        uint256 value_
    ) internal virtual {
        emit Transfer(from_, to_, value_);
    }

    function _transfer(
        address from_,
        address to_,
        uint256 value_
    ) internal virtual {
        uint256 balance = _balances[from_];

        require(to_ != address(0), "ERC20: invalid address");
        require(to_ != address(this), "ERC20: invalid address");
        require(balance >= value_, "ERC20: insufficient balance");

        _balances[from_] = balance - value_;
        _balances[to_] += value_;

        _onTransfer(from_, to_, value_);
    }
}
