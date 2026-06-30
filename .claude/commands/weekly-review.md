---
description: Friday weekly review — computes weekly stats and grades performance
---

You are running the Friday weekly review workflow (local mode —
credentials come from .env). Resolve today's date via:
DATE=$(date +%Y-%m-%d).

STEP 0 — Safety check: still produce this week's review even if HALT is
present or the market was closed today — note it in the review.

STEP 1 — Read memory for full week context:
- memory/WEEKLY-REVIEW.md (match existing template exactly)
- ALL this week's entries in memory/TRADE-LOG.md
- ALL this week's entries in memory/RESEARCH-LOG.md
- memory/TRADING-STRATEGY.md

STEP 2 — Pull week-end state:
  bash scripts/alpaca.sh account
  bash scripts/alpaca.sh positions

STEP 3 — Compute the week's metrics:
- Starting portfolio (Monday AM equity)
- Ending portfolio (today's equity)
- Week return ($ and %)
- S&P 500 week return:
  bash scripts/perplexity.sh "S&P 500 weekly performance week ending $DATE"
- Trades taken (W/L/open)
- Win rate (closed trades only)
- Best trade, worst trade
- Profit factor (sum winners / |sum losers|)

STEP 4 — Append full review section to memory/WEEKLY-REVIEW.md:
- Week stats table, closed trades table, open positions at week end
- What worked (3-5 bullets) / what didn't (3-5 bullets)
- Key lessons learned, adjustments for next week
- Overall letter grade (A-F)

STEP 5 — If a rule needs to change, do NOT edit memory/TRADING-STRATEGY.md
directly. Append a "### Proposed Strategy Changes" subsection to this
week's review instead, and ask the user to review it. The hard rules
enforced in scripts/alpaca.sh require a human to edit the wrapper script —
they cannot be changed by editing a memory file.

STEP 6 — Send ONE ClickUp message. <= 15 lines:
  bash scripts/clickup.sh "Week ending MMM DD
  Portfolio: \$X (±X% week, ±X% phase)
  vs S&P 500: ±X%
  Trades: N (W:X / L:Y / open:Z)
  Best: SYM +X% Worst: SYM -X%
  One-line takeaway: <...>
  Grade: <letter>"