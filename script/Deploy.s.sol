// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/SuperSafeStaking.sol";
import "../src/SuperSafeProxy.sol";

contract Deploy is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerKey);

        SuperSafeStaking impl = new SuperSafeStaking();

        SuperSafeProxy proxy = new SuperSafeProxy(address(impl), "");

        SuperSafeStaking(address(proxy)).initialize();

        vm.stopBroadcast();

        console.log("Staking (impl)   :", address(impl));
        console.log("SuperSafeProxy   :", address(proxy));
    }
}
