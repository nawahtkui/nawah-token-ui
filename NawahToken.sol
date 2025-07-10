// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Nawah Token (NWTK)
 * @dev ERC20 Token with fees, locking, and ownership controls.
 */
contract NawahToken is ERC20, Ownable {
    uint8 private constant _decimals = 18;
    uint256 private constant _initialSupply = 100_000_000 * 10**_decimals;

    address public feeCollector;
    address public supportFund;

    uint256 public transferFeePercent = 1; // 1% fee
    mapping(address => uint256) public unlockTime;

    constructor(address _feeCollector, address _supportFund) ERC20("Nawah Token", "NWTK") {
        _mint(msg.sender, _initialSupply);
        feeCollector = _feeCollector;
        supportFund = _supportFund;
    }

    /**
     * @dev Mint new tokens (onlyOwner)
     */
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /**
     * @dev Burn own tokens
     */
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    /**
     * @dev Update fee collector address
     */
    function setFeeCollector(address newCollector) external onlyOwner {
        require(newCollector != address(0), "Invalid address");
        feeCollector = newCollector;
    }

    /**
     * @dev Update support fund address
     */
    function setSupportFund(address newFund) external onlyOwner {
        require(newFund != address(0), "Invalid address");
        supportFund = newFund;
    }

    /**
     * @dev Set transfer fee percentage (max 10%)
     */
    function setTransferFeePercent(uint256 fee) external onlyOwner {
        require(fee <= 10, "Fee too high");
        transferFeePercent = fee;
    }

    /**
     * @dev Lock tokens for a user for a certain duration
     */
    function lockTokens(address user, uint256 timeInSeconds) external onlyOwner {
        unlockTime[user] = block.timestamp + timeInSeconds;
    }

    /**
     * @dev Transfer override with fee and lock check
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        if (from != address(0)) {
            require(block.timestamp >= unlockTime[from], "Tokens are locked");
        }
        super._beforeTokenTransfer(from, to, amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override {
        uint256 fee = (amount * transferFeePercent) / 100;
        uint256 amountAfterFee = amount - fee;

        super._transfer(sender, feeCollector, fee);
        super._transfer(sender, recipient, amountAfterFee);
    }

    /**
     * @dev Allow owner to renounce ownership (OpenZeppelin override)
     */
    function renounceOwnership() public override onlyOwner {
        super.renounceOwnership();
    }
}
