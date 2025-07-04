// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OptionsContract is Ownable {
    IERC20 public underlyingToken;    // الرمز الذي يشمله الخيار
    IERC20 public paymentToken;       // رمز الدفع (مثلاً USDT)
    
    struct Option {
        address holder;
        uint256 strikePrice;
        uint256 amount;
        uint256 expiry;
        bool exercised;
        bool cancelled;
    }

    uint256 public optionCount;
    mapping(uint256 => Option) public options;

    event OptionCreated(uint256 indexed optionId, address indexed holder, uint256 amount, uint256 strikePrice, uint256 expiry);
    event OptionExercised(uint256 indexed optionId, address indexed holder);
    event OptionCancelled(uint256 indexed optionId);

    constructor(address _underlyingToken, address _paymentToken) {
        underlyingToken = IERC20(_underlyingToken);
        paymentToken = IERC20(_paymentToken);
    }

    function createOption(
        address _holder,
        uint256 _strikePrice,
        uint256 _amount,
        uint256 _expiry
    ) external onlyOwner returns (uint256) {
        require(_expiry > block.timestamp, "Expiry must be in future");
        require(_amount > 0, "Amount must be > 0");

        optionCount++;
        options[optionCount] = Option({
            holder: _holder,
            strikePrice: _strikePrice,
            amount: _amount,
            expiry: _expiry,
            exercised: false,
            cancelled: false
        });

        emit OptionCreated(optionCount, _holder, _amount, _strikePrice, _expiry);
        return optionCount;
    }

    function exerciseOption(uint256 _optionId) external {
        Option storage opt = options[_optionId];
        require(msg.sender == opt.holder, "Not option holder");
        require(!opt.exercised, "Already exercised");
        require(!opt.cancelled, "Option cancelled");
        require(block.timestamp <= opt.expiry, "Expired");

        uint256 cost = opt.strikePrice * opt.amount;

        require(paymentToken.transferFrom(msg.sender, owner(), cost), "Payment failed");
        require(underlyingToken.transferFrom(owner(), msg.sender, opt.amount), "Transfer failed");

        opt.exercised = true;
        emit OptionExercised(_optionId, msg.sender);
    }

    function cancelOption(uint256 _optionId) external onlyOwner {
        Option storage opt = options[_optionId];
        require(!opt.exercised, "Already exercised");
        require(!opt.cancelled, "Already cancelled");

        opt.cancelled = true;
        emit OptionCancelled(_optionId);
    }

    function getOption(uint256 _optionId) external view returns (Option memory) {
        return options[_optionId];
    }
}
