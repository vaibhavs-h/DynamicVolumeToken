# 💰 Dynamic Volume Token — Bonding Curve Token on Flow EVM Testnet

This repository contains a **Solidity smart contract** implementing a **token with dynamic pricing based on trading volume**, using a simple **linear bonding curve**. The token is deployed on the **Flow EVM Testnet**.

> 📄 **Contract Address:**  
> [`0x68AdA047f23B2C88e6ed4B66b0456E28F8724Ec0`](https://evm-testnet.flowscan.io/address/0x68AdA047f23B2C88e6ed4B66b0456E28F8724Ec0)

---

## 📌 Overview

This token uses a **linear bonding curve** to determine the price dynamically based on total supply:

\[
\text{Price}(S) = \text{basePrice} + \text{slope} \times S
\]

- **basePrice** = starting price of the token (in wei)  
- **slope** = amount by which the price increases per token minted  

This means:
- As more tokens are bought (supply increases), the price per token rises.  
- Selling tokens pays out ETH based on the *same bonding curve*, decreasing supply and lowering price for future buyers.

---

## 🌐 Network Details

- **Network:** Flow EVM Testnet  
- **Explorer:** [Flow EVM Testnet Explorer](https://evm-testnet.flowscan.io)  
- **Contract Address:** [`0x68AdA047f23B2C88e6ed4B66b0456E28F8724Ec0`](https://evm-testnet.flowscan.io/address/0x68AdA047f23B2C88e6ed4B66b0456E28F8724Ec0)

---

## 🧠 Core Features

- 📈 **Dynamic Pricing:** Linear bonding curve adjusts token price as supply changes.  
- 💸 **Buy & Sell Functions:**  
  - `buy()` — Users send ETH to buy tokens (no input needed).  
  - `sell(amount)` — Users can sell back their tokens for ETH based on current curve.  
- 🔄 **Transfer Support:** Basic ERC-20–like `transfer()` between users.  
- 🧮 **Price Estimation:** Public view functions to estimate buyable tokens or payout amounts.

---

## 📝 Key Functions

| Function | Type | Description |
|----------|------|-------------|
| `buy()` | payable | Mints tokens according to current curve, using `msg.value`. Refunds leftover wei. |
| `sell(uint256 amount)` | external | Burns tokens and pays out ETH along the bonding curve. |
| `estimateBuyTokens(uint256 valueWei)` | view | Returns how many tokens can be bought for a given ETH amount. |
| `estimateSellPayout(uint256 tokens)` | view | Returns how much ETH you'd get for selling a given number of tokens. |
| `priceAt(uint256 supply)` | view | Returns the price of the next token at a given supply. |

---

## 🛠️ Interacting with the Contract

### 1. **Buy Tokens**

You can buy tokens by calling `buy()` and attaching some ETH:

```bash
cast send 0x68AdA047f23B2C88e6ed4B66b0456E28F8724Ec0 "buy()" --value 0.01ether --rpc-url https://testnet.evm.nodes.onflow.org
