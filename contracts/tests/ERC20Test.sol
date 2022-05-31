// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../implementations/ERC173.sol";
import "../implementations/ERC20Metadata.sol";

contract ERC20Test is ERC173, ERC20Metadata {
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initialSupply_
    ) ERC20Metadata(name_, symbol_) {
        ERC20._mint(msg.sender, initialSupply_);
    }

    function burn(uint256 value_) public virtual {
        ERC20._burn(msg.sender, value_);
    }

    function burnFrom(address owner_, uint256 value_) public virtual {
        uint256 currentAllowance = ERC20.allowance(owner_, msg.sender);

        require(currentAllowance >= value_, "ERC20: insufficient allowance");

        ERC20._approve(owner_, msg.sender, currentAllowance - value_);

        ERC20._burn(owner_, value_);
    }

    function mint(address to_, uint256 value_) public virtual onlyOwner {
        ERC20._mint(to_, value_);
    }
}
