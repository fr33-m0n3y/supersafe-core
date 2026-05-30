// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/SuperSafeStaking.sol";
import "../src/SuperSafeProxy.sol";

contract Deploy is Script {
    bytes32 constant SALT = keccak256("supersafe-v1");

    function run() external {
        vm.startBroadcast();

        SuperSafeStaking impl = new SuperSafeStaking{salt: SALT}();
        SuperSafeProxy proxy = new SuperSafeProxy{salt: SALT}(address(impl), "");
        SuperSafeStaking(address(proxy)).initialize();

        vm.stopBroadcast();

        console.log("Staking (impl)   :", address(impl));
        console.log("SuperSafeProxy   :", address(proxy));
    }
}
