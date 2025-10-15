// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/*
  DynamicVolumeToken
  - Integer-token (decimals = 0) for simpler, safe bonding-curve math
  - Price per token = basePrice + slope * supply
  - Cost to mint q tokens given current supply S:
      cost = base*q + slope*(S*q + q^2/2)
    Derived quadratic is solved for q when given msg.value
  - No imports, no constructor
  - Simple buy() payable (no params) and sell(uint256 amount) functions
*/

contract DynamicVolumeToken {
    string public name = "DynamicVolumeToken";
    string public symbol = "DVT";
    uint8 public constant decimals = 0; // integer tokens for simpler math

    // Hardcoded parameters (change in source if desired)
    // basePrice: wei per token at supply = 0
    // slope: wei added to price per each additional token in circulation
    uint256 public basePrice = 1e15; // 0.001 ETH per token (example)
    uint256 public slope = 1e12;     // 0.000001 ETH additional per token per token

    // Accounting
    uint256 public totalSupply; // circulating tokens (integer)
    mapping(address => uint256) public balanceOf;

    // Events
    event Buy(address indexed buyer, uint256 tokens, uint256 cost);
    event Sell(address indexed seller, uint256 tokens, uint256 payout);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    // ---- Public view helpers ----

    // Price per single token at given supply (wei)
    // price(S) = basePrice + slope * S
    function priceAt(uint256 _supply) public view returns (uint256) {
        return basePrice + slope * _supply;
    }

    // Estimate tokens you would get for `value` wei given current supply.
    // This computes the integer q >= 0 solving the integral-based quadratic.
    function estimateBuyTokens(uint256 valueWei) public view returns (uint256) {
        if (valueWei == 0) return 0;

        uint256 S = totalSupply;
        uint256 b = basePrice + slope * S; // coefficient b
        // If slope == 0 then price constant: q = value / b
        if (slope == 0) {
            return valueWei / b;
        }

        // Solve a*q^2 + b*q - m = 0 where a = slope/2, m = valueWei
        // q = ( -b + sqrt(b^2 + 2*slope*m) ) / slope
        // All integers; ensure discriminant computation safe
        uint256 discriminant = b * b + 2 * slope * valueWei;
        uint256 root = _sqrt(discriminant);
        if (root <= b) return 0;
        uint256 q = (root - b) / slope;
        return q;
    }

    // Estimate wei you would get for selling `tokens` (must be <= totalSupply)
    function estimateSellPayout(uint256 tokens) public view returns (uint256) {
        require(tokens <= totalSupply, "tokens exceed supply");
        uint256 S = totalSupply;
        // payout = base*q + slope*(S*q - q^2/2)
        // compute carefully: all integers; q^2/2 uses integer division (floor)
        uint256 q = tokens;
        uint256 term1 = basePrice * q;
        uint256 term2_part1 = slope * S * q; // slope*S*q
        uint256 term2_part2 = (slope * q * q) / 2; // slope * q^2 / 2
        uint256 payout = term1 + (term2_part1 - term2_part2);
        return payout;
    }

    // ---- Core actions ----

    // Buy tokens by sending ETH. No parameters; amount determined by msg.value.
    // Mints whole tokens to msg.sender. Refund leftover wei < price of 1 token.
    function buy() external payable {
        uint256 paid = msg.value;
        require(paid > 0, "send ETH to buy tokens");

        uint256 tokens = estimateBuyTokens(paid);
        require(tokens > 0, "insufficient value to buy any token");

        // compute exact cost for `tokens` to avoid overcharging
        uint256 cost = _costToMint(tokens);
        require(cost <= paid, "internal cost calc mismatch");

        // mint tokens
        balanceOf[msg.sender] += tokens;
        totalSupply += tokens;

        // refund remainder if any
        uint256 refund = paid - cost;
        if (refund > 0) {
            // using call to refund
            (bool sent, ) = payable(msg.sender).call{value: refund}("");
            require(sent, "refund failed");
        }

        emit Buy(msg.sender, tokens, cost);
    }

    // Sell `amount` tokens back to contract, receive wei according to bonding curve.
    // Requires contract to have sufficient ETH balance to pay — caller must trust contract.
    function sell(uint256 amount) external {
        require(amount > 0, "sell amount zero");
        require(balanceOf[msg.sender] >= amount, "insufficient tokens");

        uint256 payout = estimateSellPayout(amount);

        // burn tokens
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;

        // transfer ETH payout
        (bool sent, ) = payable(msg.sender).call{value: payout}("");
        require(sent, "payout failed");

        emit Sell(msg.sender, amount, payout);
    }

    // Basic transfer between users (simple ERC20-like)
    function transfer(address to, uint256 amount) external returns (bool) {
        require(to != address(0), "zero address");
        require(balanceOf[msg.sender] >= amount, "insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // ---- Internal math ----

    // exact cost to mint q tokens starting from current supply S:
    // cost = base*q + slope*(S*q + q^2/2)
    function _costToMint(uint256 q) internal view returns (uint256) {
        uint256 S = totalSupply;
        uint256 term1 = basePrice * q;
        uint256 term2_part1 = slope * S * q;
        uint256 term2_part2 = (slope * q * q) / 2;
        uint256 cost = term1 + (term2_part1 + term2_part2);
        return cost;
    }

    // Babylonian sqrt for uint256
    function _sqrt(uint256 x) internal pure returns (uint256 y) {
        if (x == 0) return 0;
        uint256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }

    // Allow contract to receive ETH (e.g., for payouts) — funds stay in contract balance
    receive() external payable {}
    fallback() external payable {}
}
