# SuperSafeStaking

**Liquid ETH staking, simplified.**

SuperSafeStaking lets you deposit ETH and instantly receive **SSETH** — a fully transferable ERC-20 receipt token backed 1:1 by your staked ETH. No lock-up periods. No intermediaries. Withdraw anytime.

---

## Why SuperSafeStaking?

- **Instant liquidity** — SSETH is a standard ERC-20. Trade, transfer, or use it in other protocols while your ETH keeps working.
- **Non-custodial** — your ETH is held entirely in the contract. No third-party custody.
- **Upgradeable** — the protocol can be improved over time without requiring users to migrate funds.
- **Minimal surface area** — purpose-built staking logic with no unnecessary complexity.

---

## How It Works

1. Call `deposit()` with any amount of ETH
2. Receive the equivalent amount of SSETH immediately
3. Hold, transfer, or use your SSETH freely
4. Call `withdraw(amount)` at any time to burn SSETH and reclaim ETH

---

## Contracts

| Contract | Description |
|---|---|
| `SuperSafeStaking` | Core staking logic and SSETH token |
| `SuperSafeProxy` | Upgradeable proxy |

---

## Security

The codebase has been reviewed by **Veridian Security**. Internal report on file.

- Owner-gated upgrades — only the protocol owner can push implementation changes
- Reentrancy-safe withdrawal flow
- Storage layout strictly maintained across upgrades
