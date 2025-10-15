# 💰 Dynamic Volume Token — Bonding Curve Token on Flow EVM Testnet

This repository contains a **Solidity smart contract** implementing a **token with dynamic pricing based on trading volume** using a simple **linear bonding curve**.  
The token is deployed on the **Flow EVM Testnet**.

> 📄 **Deployed Contract Address:**  
> [`0x68AdA047f23B2C88e6ed4B66b0456E28F8724Ec0`](https://evm-testnet.flowscan.io/address/0x68AdA047f23B2C88e6ed4B66b0456E28F8724Ec0)

---

## 📌 Overview

The token’s price is determined by a **linear bonding curve** based on the total supply:

\[
\text{Price}(S) = \text{basePrice} + \text{slope} \times S
\]

- **basePrice** → starting price per token (in wei)  
- **slope** → how much the price increases with each token minted  

### ✨ Key Idea:
- As more tokens are **bought**, supply increases → price goes up.  
- When tokens are **sold**, supply decreases → price goes down accordingly.  
- Buyers pay ETH to mint new tokens at the current curve price.  
- Sellers receive ETH based on the same curve when burning tokens.

---

## 🌐 Network Details

- **Network:** Flow EVM Testnet  
- **Explorer:** [Flow EVM Testnet Explorer](https://evm-testnet.flowscan.io)  
- **Contract Address:** [`0x68AdA047f23B2C88e6ed4B66b0456E28F8724Ec0`](https://evm-testnet.flowscan.io/address/0x68AdA047f23B2C88e6ed4B66b0456E28F8724Ec0)

---

## 🧠 Core Features

- 📈 **Dynamic Pricing** — Linear bonding curve adjusts price as total supply changes.  
- 💸 **Buy / Sell Mechanism** — Users can buy tokens with ETH and sell them back at curve value.  
- 🔄 **Basic ERC-20–like Transfers** — `transfer()` function included.  
- 🧮 **Price Estimation Functions** — `estimateBuyTokens()` and `estimateSellPayout()` for frontends or wallets.

---

## 📝 Key Contract Functions

| Function | Type | Description |
|----------|------|-------------|
| `buy()` | payable | Buy tokens with ETH. The amount of tokens depends on `msg.value`. |
| `sell(uint256 amount)` | external | Sell tokens back for ETH based on the current curve. |
| `estimateBuyTokens(uint256 valueWei)` | view | Estimate how many tokens you can buy for a given amount of ETH. |
| `estimateSellPayout(uint256 tokens)` | view | Estimate how much ETH you'd get for selling a given amount of tokens. |
| `priceAt(uint256 supply)` | view | Check the current price of the next token at a given supply. |

---

## 🛠️ Interacting with the Contract

### 1️⃣ **Buy Tokens**

Using [Remix](https://remix.ethereum.org/):

1. Open Remix and connect to Flow EVM Testnet.  
2. Load the contract ABI and set the deployed address.  
3. Go to the `buy()` function.  
4. Enter the ETH amount in the “Value” field (e.g. `0.01 ether`) and click **Transact**.

Or with **Foundry** / `cast`:

```bash
cast send 0x68AdA047f23B2C88e6ed4B66b0456E28F8724Ec0 "buy()" \
  --value 0.01ether \
  --rpc-url https://testnet.evm.nodes.onflow.org
