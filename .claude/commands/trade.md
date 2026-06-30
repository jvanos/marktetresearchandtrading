---
description: Manual trade helper with strategy-rule validation. Usage — /trade SYMBOL SHARES buy|sell
---

Execute a manual trade with full rule validation. Refuse if any rule fails.

Args: SYMBOL SHARES SIDE (buy or sell). If missing, ask.

0. Safety check: if a file named HALT exists at the repo root, tell the
   user explicitly ("HALT file present — trading is paused. Remove HALT to
   resume.") and stop here; do not proceed. Run `bash scripts/alpaca.sh
   clock` — if the market is closed, tell the user and stop.
1. Pull state: account, positions, quote SYMBOL (capture ask price P).
2. For SELL, confirm position exists with right qty. No other checks —
   sells are never blocked by the wrapper gates.
3. Print the order JSON, ask "execute? (y/n)".
4. On confirm:
   bash scripts/alpaca.sh order '{"symbol":"SYM","qty":"N","side":"buy|sell","type":"market","time_in_force":"day"}'
   For BUYs, the wrapper validates the order in code (no options, max 6
   positions, max 20% of equity, max 3 trades/week, cost <= buying_power,
   daily-loss circuit breaker) before it reaches Alpaca. If it exits 2,
   print the rejection reason verbatim to the user and stop — do not
   retry with a smaller size to route around the rejection.
5. For BUYs that succeed, immediately place 10% trailing stop GTC (same
   flow as market-open).
6. Log to memory/TRADE-LOG.md with full thesis, entry, stop, target, R:R.
7. bash scripts/clickup.sh with trade details.