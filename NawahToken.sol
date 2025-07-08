// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract NawahToken is Initializable, ERC20Upgradeable, OwnableUpgradeable {
    uint256 public transactionFeeBP;
    uint256 public supportFeeBP;
    address public feeCollector;
    address public supportFund;

    uint256 public accumulatedFeeCollector;
    uint256 public accumulatedSupportFund;

    event FeeCollectorChanged(address indexed oldCollector, address indexed newCollector);
    event SupportFundChanged(address indexed oldFund, address indexed newFund);
    event TransactionFeeBPChanged(uint256 oldFee, uint256 newFee);
    event SupportFeeBPChanged(uint256 oldSupportFee, uint256 newSupportFee);
    event FeesWithdrawn(address indexed to, uint256 amount);

    function initialize() public initializer {
        __ERC20_init("Nawah Token", "NWTK");
        __Ownable_init();

        feeCollector = msg.sender;
        supportFund = msg.sender;

        transactionFeeBP = 50;   // 0.5%
        supportFeeBP = 5000;     // 50% من الرسوم للدعم

        _mint(msg.sender, 100_000_000 * 10 ** decimals());
    }

    function setFeeCollector(address newCollector) external onlyOwner {
        require(newCollector != address(0), "Fee collector cannot be zero");
        emit FeeCollectorChanged(feeCollector, newCollector);
        feeCollector = newCollector;
    }

    function setSupportFund(address newFund) external onlyOwner {
        require(newFund != address(0), "Support fund cannot be zero");
        emit SupportFundChanged(supportFund, newFund);
        supportFund = newFund;
    }

    function setTransactionFeeBP(uint256 newFeeBP) external onlyOwner {
        require(newFeeBP <= 500, "Fee cannot exceed 5%");
        emit TransactionFeeBPChanged(transactionFeeBP, newFeeBP);
        transactionFeeBP = newFeeBP;
    }

    function setSupportFeeBP(uint256 newSupportFeeBP) external onlyOwner {
        require(newSupportFeeBP <= 10000, "Support fee cannot exceed 100%");
        emit SupportFeeBPChanged(supportFeeBP, newSupportFeeBP);
        supportFeeBP = newSupportFeeBP;
    }

    function withdrawFeeCollector() external {
        uint256 amount = accumulatedFeeCollector;
        require(amount > 0, "No fees to withdraw");
        require(msg.sender == feeCollector, "Only feeCollector can withdraw");

        accumulatedFeeCollector = 0;
        _transfer(address(this), feeCollector, amount);
        emit FeesWithdrawn(feeCollector, amount);
    }

    function withdrawSupportFund() external {
        uint256 amount = accumulatedSupportFund;
        require(amount > 0, "No fees to withdraw");
        require(msg.sender == supportFund, "Only supportFund can withdraw");

        accumulatedSupportFund = 0;
        _transfer(address(this), supportFund, amount);
        emit FeesWithdrawn(supportFund, amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override {
        if (transactionFeeBP == 0 || sender == feeCollector || sender == supportFund) {
            super._transfer(sender, recipient, amount);
            return;
        }

        uint256 totalFee = (amount * transactionFeeBP) / 10000;
        uint256 supportAmount = (totalFee * supportFeeBP) / 10000;
        uint256 feeCollectorAmount = totalFee - supportAmount;
        uint256 amountAfterFee = amount - totalFee;

        accumulatedFeeCollector += feeCollectorAmount;
        accumulatedSupportFund += supportAmount;

        super._transfer(sender, recipient, amountAfterFee);
        super._transfer(sender, address(this), totalFee);
    }
}


