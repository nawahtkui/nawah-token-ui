// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract NawahToken is Initializable, ERC20Upgradeable, OwnableUpgradeable {

    uint256 public transactionFeeBP;
    uint256 public accumulatedFees;
    address public feeCollector;

    function initialize(address _feeCollector) public initializer {
        __ERC20_init("Nawah Token", "NWTK");
        __Ownable_init();
        transactionFeeBP = 200; // 2%
        feeCollector = _feeCollector;
        accumulatedFees = 0;
        _mint(msg.sender, 100_000_000 * 10 ** decimals());
    }

    function setTransactionFeeBP(uint256 feeBP) external onlyOwner {
        require(feeBP <= 500, "Max 5%");
        transactionFeeBP = feeBP;
    }

    function setFeeCollector(address collector) external onlyOwner {
        feeCollector = collector;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
        uint256 fee = (amount * transactionFeeBP) / 10000;
        uint256 amountAfterFee = amount - fee;
        accumulatedFees += fee;
        super._transfer(sender, recipient, amountAfterFee);
        super._transfer(sender, feeCollector, fee);
    }
}
