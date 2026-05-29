// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/Proxy.sol";

contract SuperSafeProxy is Proxy {
    // Non-EIP-1967 custom slot: keccak256("dfc2026")
    bytes32 private constant IMPLEMENTATION_SLOT =
        bytes32(uint256(keccak256("dfc2026")));

    // slot 0
    address private _owner;

    constructor(address implementation, bytes memory initData) {
        _owner = msg.sender;
        _setImplementation(implementation);
        if (initData.length > 0) {
            (bool ok,) = implementation.delegatecall(initData);
            require(ok, "SuperSafeProxy: init failed");
        }
    }

    function upgradeTo(address newImpl) external {
        require(msg.sender == _owner, "SuperSafeProxy: not owner");
        _setImplementation(newImpl);
    }

    function getImplementation() external view returns (address) {
        return _implementation();
    }

    function _implementation() internal view override returns (address impl) {
        bytes32 slot = IMPLEMENTATION_SLOT;
        assembly {
            impl := sload(slot)
        }
    }

    function _setImplementation(address impl) private {
        bytes32 slot = IMPLEMENTATION_SLOT;
        assembly {
            sstore(slot, impl)
        }
    }

    receive() external payable {}
}
