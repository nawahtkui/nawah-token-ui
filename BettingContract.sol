// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

interface INawahToken {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
}

contract BettingContract is OwnableUpgradeable {
    INawahToken public nawahToken;

    struct Bet {
        uint256 amount;
        bool settled;
        bool won;
    }

    mapping(address => Bet) public bets;

    event BetPlaced(address indexed user, uint256 amount);
    event BetSettled(address indexed user, bool won, uint256 payout);

    function initialize(address tokenAddress) public initializer {
        __Ownable_init();
        nawahToken = INawahToken(tokenAddress);
    }

    function placeBet(uint256 amount) external {
        require(amount > 0, "Invalid amount");
        require(nawahToken.transferFrom(msg.sender, address(this), amount), "Token transfer failed");
        require(!bets[msg.sender].settled, "Bet already active");

        bets[msg.sender] = Bet({amount: amount, settled: false, won: false});
        emit BetPlaced(msg.sender, amount);
    }

    function settleBet(address user, bool won, uint256 payout) external onlyOwner {
        Bet storage bet = bets[user];
        require(!bet.settled, "Bet already settled");

        bet.settled = true;
        bet.won = won;

        if (won) {
            require(nawahToken.transfer(user, payout), "Payout failed");
        }
        emit BetSettled(user, won, payout);
    }

    // يمكن إضافة وظائف لإدارة رصيد الرهانات، إيداع الأموال، إلخ.
}
