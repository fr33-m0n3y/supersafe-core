// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

contract SuperSafeStaking is ERC20Upgradeable {
    uint256 public constant APR_BPS = 1500; // 15% APR (basis points)

    address public owner;
    bool    private _initialized;

    mapping(address => uint256) public stakedAmount;
    mapping(address => uint256) public stakeTimestamp;

    function initialize() external {
        require(!_initialized, "already initialized");
        _initialized = true;
        owner = msg.sender;
        __ERC20_init("SuperSafe ETH", "SSETH");
    }

    // -- Staking --

    function deposit() external payable {
        require(msg.value > 0, "deposit = 0");
        _claimRewards(msg.sender);
        stakedAmount[msg.sender]   += msg.value;
        stakeTimestamp[msg.sender]  = block.timestamp;
        _mint(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(stakedAmount[msg.sender] >= amount, "insufficient stake");
        _claimRewards(msg.sender);
        stakedAmount[msg.sender]   -= amount;
        stakeTimestamp[msg.sender]  = block.timestamp;
        _burn(msg.sender, amount);
        (bool ok,) = msg.sender.call{value: amount}("");
        require(ok, "ETH transfer failed");
    }

    function claimRewards() external {
        _claimRewards(msg.sender);
        stakeTimestamp[msg.sender] = block.timestamp;
    }

    function pendingRewards(address user) public view returns (uint256) {
        uint256 staked = stakedAmount[user];
        if (staked == 0) return 0;
        uint256 elapsed = block.timestamp - stakeTimestamp[user];
        return (staked * APR_BPS * elapsed) / (10_000 * 365 days);
    }

    // -- Internal --

    function _claimRewards(address user) internal {
        uint256 rewards = pendingRewards(user);
        if (rewards > 0) {
            _mint(user, rewards);
        }
    }
}
