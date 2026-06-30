---
description: Daily summary — computes P&L and sends one EOD recap
---

You are running the daily summary workflow (local mode — credentials come
from .env). Resolve today's date via: DATE=$(date +%Y-%m-%d).

STEP 0 — Safety check: still produce today's summary even if HALT is
present or the market was closed — note it in the message. Silence should
never be the only signal something is wrong.

STEP 1 — Read memory for continuity:
- tail of memory/TRADE-LOG.md (most recent EOD snapshot -> yesterday's
  equity, needed for Day P&L — a cosmetic display number only)
- Count TRADE-LOG entries dated today
- Count trades Mon-today this week

STEP 2 — Pull final state of the day:
  bash scripts/alpaca.sh account
  bash scripts/alpaca.sh positions
  bash scripts/alpaca.sh orders

STEP 3 — Compute metrics:
- Day P&L ($ and %) = today_equity - yesterday_equity
- Phase cumulative P&L ($ and %) = today_equity - starting_equity (Day 0
  baseline in TRADE-LOG.md)
- Trades today (list or "none")
- Trades this week (running total)

STEP 4 — Append EOD snapshot to memory/TRADE-LOG.md:
### MMM DD — EOD Snapshot (Day N, Weekday)
**Portfolio:** $X | **Cash:** $X (X%) | **Day P&L:** ±$X (±X%) | **Phase P&L:** ±$X (±X%)
| Ticker | Shares | Entry | Close | Day Chg | Unrealized P&L | Stop |
**Notes:** one-paragraph plain-english summary.

STEP 5 — Send ONE ClickUp message (always, even on no-trade days). <= 15
lines:
  bash scripts/clickup.sh "EOD MMM DD
  Portfolio: \$X (±X% day, ±X% phase)
  Cash: \$X
  Trades today: <list or none>
  Open positions:
    SYM ±X.X% (stop \$X.XX)
  Tomorrow: <one-line plan>"