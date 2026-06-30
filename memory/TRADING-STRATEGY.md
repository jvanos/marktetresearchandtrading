# Trading Strategy

## Mission
Beat the S&P 500 over the challenge window. Stocks only — no options, ever.

## Capital & Constraints
- Starting capital: ~$10,000
- Platform: Alpaca (paper trading by default — see env.template)
- Instruments: Stocks ONLY

## Core Rules
1. NO OPTIONS — ever (enforced in scripts/alpaca.sh, not just this doc)
2. 75-85% deployed
3. 5-6 positions at a time, max 20% each (position-count and 20% cap also
   enforced in scripts/alpaca.sh)
4. 10% trailing stop on every position as a real GTC order
5. Cut losers at -7% manually
6. Tighten trail: 7% at +15%, 5% at +20%
7. Never within 3% of current price; never move a stop down
8. Max 3 new trades per week (enforced in scripts/alpaca.sh)
9. Follow sector momentum
10. Exit a sector after 2 consecutive failed trades
11. Patience > activity

## Enforcement note
Rules 1, 3, and 8 above, plus a cost-vs-buying_power check and a daily-loss
circuit breaker, are validated in code inside `scripts/alpaca.sh` — a BUY
order that breaks one of these is rejected before it reaches Alpaca,
regardless of what any prompt or research output suggests. See CLAUDE.md
"Safety Mechanisms" for the full list. Changing these limits requires a
human to edit the wrapper script directly — they cannot be loosened by
editing this file. See `routines/weekly-review.md` STEP 5.

## Entry Checklist
- Specific catalyst?
- Sector in momentum?
- Stop level (7-10% below entry)
- Target (min 2:1 R:R)