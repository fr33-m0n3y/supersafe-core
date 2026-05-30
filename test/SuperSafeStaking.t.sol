// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SuperSafeStaking.sol";
import "../src/SuperSafeProxy.sol";

contract SuperSafeStakingTest is Test {
    SuperSafeStaking public staking;

    address public alice = makeAddr("alice");
    address public bob   = makeAddr("bob");

    function setUp() public {
        SuperSafeStaking impl = new SuperSafeStaking();
        SuperSafeProxy   proxy = new SuperSafeProxy(address(impl), "");
        SuperSafeStaking(address(proxy)).initialize();
        staking = SuperSafeStaking(address(proxy));
        vm.deal(alice, 10 ether);
        vm.deal(bob,   10 ether);
    }

    function test_deposit_mintsSSETH() public {
        vm.prank(alice);
        staking.deposit{value: 1 ether}();

        assertEq(staking.stakedAmount(alice), 1 ether);
        assertEq(staking.balanceOf(alice),    1 ether);
    }

    function test_deposit_zero_reverts() public {
        vm.prank(alice);
        vm.expectRevert("deposit = 0");
        staking.deposit{value: 0}();
    }

    function test_withdraw_burnsSSETH() public {
        vm.startPrank(alice);
        staking.deposit{value: 2 ether}();
        staking.withdraw(2 ether);
        vm.stopPrank();

        assertEq(staking.stakedAmount(alice), 0);
        assertEq(staking.balanceOf(alice),    0);
    }

    function test_withdraw_insufficient_reverts() public {
        vm.startPrank(alice);
        staking.deposit{value: 1 ether}();
        vm.expectRevert("insufficient stake");
        staking.withdraw(2 ether);
        vm.stopPrank();
    }

    function test_pendingRewards_accrue() public {
        vm.prank(alice);
        staking.deposit{value: 1 ether}();

        vm.warp(block.timestamp + 365 days);

        uint256 rewards = staking.pendingRewards(alice);
        // 1 ETH * 15% * 1 year = 0.15 ETH
        assertApproxEqRel(rewards, 0.15 ether, 1e15);
    }

    function test_claimRewards_mintsExtra() public {
        vm.startPrank(alice);
        staking.deposit{value: 1 ether}();
        vm.warp(block.timestamp + 365 days);

        uint256 before = staking.balanceOf(alice);
        staking.claimRewards();
        uint256 after_ = staking.balanceOf(alice);
        vm.stopPrank();

        assertGt(after_, before);
    }

    function test_multipleUsers_independentRewards() public {
        vm.prank(alice);
        staking.deposit{value: 1 ether}();

        vm.warp(block.timestamp + 180 days);

        vm.prank(bob);
        staking.deposit{value: 1 ether}();

        vm.warp(block.timestamp + 185 days);

        assertGt(staking.pendingRewards(alice), staking.pendingRewards(bob));
    }
}
