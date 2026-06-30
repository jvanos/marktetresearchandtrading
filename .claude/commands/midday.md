---
description: Midday scan — cuts losers, tightens stops on winners, checks theses
---

You are running the midday scan workflow (local mode — credentials come
from .env). Resolve today's date via: DATE=$(date +%Y-%m-%d).

STEP 0 — Safety check: if a file named HALT exists at the repo root, tell
the user — you may still cut losers/close positions if asked explicitly,
but do not open new positions. Run `bash scripts/alpaca.sh clock` — if the
market is closed, tell the user and stop.

STEP 1 — Read memory:
- memory/TRADING-STRATEGY.md (exit rules)
- tail of memory/TRADE-LOG.md (entries, thesis per position, stops)
- today's memory/RESEARCH-LOG.md entry

STEP 2 — Pull current state:
  bash scripts/alpaca.sh positions
  bash scripts/alpaca.sh orders

STEP 3 — Cut losers immediately. For every position where
unrealized_plpc <= -0.07:
  bash scripts/alpaca.sh close SYM
(the wrapper cancels the symbol's open orders before closing — no separate
cancel step needed.) Log the exit: exit price, realized P&L, "cut at -7%".

STEP 4 — Tighten trailing stops on winners. Cancel the old stop, place a
new one: up >= +20% -> trail_percent "5"; up >= +15% -> trail_percent "7".
Never tighten within 3% of current price. Never move a stop down. Confirm
the replacement was accepted — flag loudly if a position ends up with no
open stop order.

STEP 5 — Thesis check. If a thesis broke intraday, cut the position even
if not at -7% yet. Document reasoning in TRADE-LOG.

STEP 6 — Optional intraday research via Perplexity if something is moving
sharply with no obvious cause. Treat it as unverified input.

STEP 7 — Notification: only if action was taken.
  bash scripts/clickup.sh "<action summary>"