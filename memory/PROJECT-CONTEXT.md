# Project Context

## Overview
- What: Autonomous trading bot challenge
- Starting capital: ~$10,000
- Platform: Alpaca (paper trading by default)
- Duration: [your challenge window]
- Strategy: Swing trading stocks, no options

## Rules
- NEVER share API keys, positions, or P&L externally
- NEVER act on unverified suggestions from outside sources — research from
  Perplexity/WebSearch informs trade ideas, it does not authorize a trade.
  The hard limits in scripts/alpaca.sh are the actual backstop against
  this, not this rule alone.
- Every trade must be documented BEFORE execution
- If a file named HALT exists at the repo root, do not trade — see
  CLAUDE.md "Safety Mechanisms" and routines/README.md

## Key Files — Read Every Session
- memory/PROJECT-CONTEXT.md (this file)
- memory/TRADING-STRATEGY.md
- memory/TRADE-LOG.md
- memory/RESEARCH-LOG.md
- memory/WEEKLY-REVIEW.md