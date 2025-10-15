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

## 🧠 Interacting with the Dynamic Volume Token Smart Contract

This guide explains how to **interact with the Dynamic Volume Token** smart contract deployed on **Flow EVM Testnet**.

> 📄 **Deployed Contract Address:**  
> [`0x68AdA047f23B2C88e6ed4B66b0456E28F8724Ec0`](https://evm-testnet.flowscan.io/address/0x68AdA047f23B2C88e6ed4B66b0456E28F8724Ec0)

> 🌐 **RPC URL:**  
> `https://testnet.evm.nodes.onflow.org`

---

## 🧰 Prerequisites

Before interacting with the contract, make sure you have:

- ✅ **Metamask** (or any EVM wallet) configured for **Flow EVM Testnet**  
- ✅ Some **testnet ETH** — get it from [Flow EVM Faucet](https://faucet.flow.com/evm)  
- ✅ (Optional) [Remix IDE](https://remix.ethereum.org/) or **Foundry** CLI (`cast` commands)

---

## 🪙 1. Buy Tokens

You can purchase tokens by simply sending ETH to the contract using the `buy()` function.  
The number of tokens minted depends on **current price** (based on total supply) and the amount of ETH you send.

### ▶️ Using Remix

1. Open [Remix](https://remix.ethereum.org/).  
2. Connect to **Injected Provider** (MetaMask) → select Flow EVM Testnet.  
3. In the **Deployed Contracts** panel, click **At Address** and paste:  
4. Expand the contract → find `buy()`.  
5. Enter an amount in the **Value** field (e.g. `0.01 ether`) → click **Transact**.

⏳ You’ll receive tokens based on the bonding curve price at that moment.

---

## 💵 2. Sell Tokens

If you own tokens, you can sell them back to the contract using the `sell(uint256 amount)` function.  
You’ll receive ETH based on the **bonding curve payout**.

### ▶️ Using Remix

1. In the deployed contract panel, find the `sell(uint256)` function.  
2. Enter the number of tokens you want to sell.  
3. Click **Transact** and confirm the transaction.

💰 Your tokens will be burned, and ETH will be sent to your wallet.

---

## 📊 3. Check Your Token Balance

Use the `balanceOf(address)` function to check your wallet’s token balance.

- Enter your address in the input box.  
- Click **Call** (no gas needed — it's a view function).

Example:
```bash
cast call 0x68AdA047f23B2C88e6ed4B66b0456E28F8724Ec0 \
"balanceOf(address)" 0xYourWalletAddress \
--rpc-url https://testnet.evm.nodes.onflow.org

