# Weekly Review

Friday reviews appended here.
Template for each entry:

## Week ending YYYY-MM-DD

### Stats
| Metric | Value |
|--------|-------|
| Starting portfolio | $X |
| Ending portfolio | $X |
| Week return | ±$X (±X%) |
| S&P 500 week | ±X% |
| Bot vs S&P | ±X% |
| Trades | N (W:X / L:Y / open:Z) |
| Win rate | X% |
| Best trade | SYM +X% |
| Worst trade | SYM -X% |
| Profit factor | X.XX |

### Closed Trades
| Ticker | Entry | Exit | P&L | Notes |

### Open Positions at Week End
| Ticker | Entry | Close | Unrealized | Stop |

### What Worked
- ...

### What Didn't Work
- ...

### Key Lessons
- ...

### Adjustments for Next Week
- ...

### Proposed Strategy Changes
(Optional — see TRADING-STRATEGY.md "Enforcement note". Propose changes
here for human review; do not edit TRADING-STRATEGY.md directly.)

### Overall Grade: X

---

## Week ending 2026-07-17

*Note: Market open all 5 days (Jul 13–17). No HALT file. Normal operations throughout. Market closed 4:07 PM ET when this review ran.*

### Stats
| Metric | Value |
|--------|-------|
| Starting portfolio | $100,308.42 |
| Ending portfolio | $100,877.94 |
| Week return | +$569.52 (+0.57%) |
| S&P 500 week | -1.60% |
| Bot vs S&P | +2.17% |
| Trades | 1 (W:0 / L:0 / open:4) |
| Win rate | N/A (no closed trades) |
| Best trade | XLE +2.19% unrealized |
| Worst trade | XLB -3.13% unrealized |
| Profit factor | N/A (no closed trades) |

### Closed Trades
| Ticker | Entry | Exit | P&L | Notes |
|--------|-------|------|-----|-------|
| — | — | — | — | No closed trades this week |

### Open Positions at Week End
| Ticker | Entry | Close | Unrealized | Stop |
|--------|-------|-------|------------|------|
| MSFT | $370.73 | $394.04 | +$1,235.58 (+6.29%) | $365.391 (10% trail, HWM $405.99) |
| XLB | $52.09 | $50.46 | -$475.08 (-3.13%) | $46.872 (10% trail, HWM $52.08) |
| XLE | $56.56 | $57.80 | +$438.96 (+2.19%) | $52.3035 (10% trail, HWM $58.115) |
| XLI | $183.18 | $179.26 | -$321.49 (-2.14%) | $164.808 (10% trail, HWM $183.12) |

### What Worked
- XLE entry thesis timed well — June CPI beat (3.5% vs 3.9% est.) cleared binary risk; Iran/Hormuz oil spike became a direct tailwind, pushing HWM and trailing stop higher through the week
- MSFT broke $400 intraday Thursday; stop auto-advanced to $365.39; Azure AI + Frontier launch thesis intact into Jul 29 earnings
- Sector diversification paid off: energy (XLE +2.19%) offset tech/industrial risk-off drag on Friday's Hormuz sell-down
- Patience on XLF (worst sector YTD) — correctly avoided a fundamentally weak 5th slot
- Bot outperformed S&P 500 by +2.17% in a losing week for the index; risk management working

### What Didn't Work
- Deployment still 70% vs 75-85% mandate — no compelling 5th-slot candidate found for the 4th consecutive week
- XLB persistent drag: buy→hold downgrade Jul 8 + technical weakness (below 50-DMA, MACD neg) with no recovery catalyst; -3.13% unrealized, HWM frozen at entry ($52.08)
- XLI underperforming since entry: -2.14% unrealized, no HWM advance, trailing stop unmoved (HWM still $183.12 from entry Jul 7)
- MSFT risk-off Friday (-1.93%) erased most of Thursday's $400 breakout; Hormuz/Iran overhang weighing on NASDAQ names
- Missing EOD snapshots (Jul 9, Jul 10) created tracking gaps; week starting equity estimated from Alpaca last_equity rather than confirmed snapshot

### Key Lessons
- Iran/Hormuz as a recurrent risk factor creates consistent sector divergence — XLE wins, MSFT/NASDAQ loses; holding energy as a hedge against geopolitical spikes is sound
- Sector diversification proved its value this week: 4-position portfolio returned +0.57% vs S&P -1.60% with no single position dominating
- XLB at 9 days post-downgrade with no recovery is approaching the threshold for voluntary exit; waiting for the trailing stop alone may not be optimal when fundamentals have clearly deteriorated
- Commit daily EOD snapshots — gaps cost accuracy in weekly accounting and make it harder to compute true daily attribution

### Adjustments for Next Week
- XLB watch: if no positive catalyst or HWM advance by Jul 21-22 midday, consider voluntary exit before -7% floor ($48.45); fundamentals (analyst downgrade) + technicals (below 50-DMA) justify discretionary cut
- 5th slot: if XLB exits, replace with a momentum name (GOOGL pre-earnings Jul 29, or individual Industrials vs. broad ETF)
- MSFT tighten alert: $426.34 threshold ~8.3% away; if Jul 29 earnings delivers, trail tightens to 7% — pre-plan the GTC stop modification
- XLE: let stop work; HWM auto-advancing; no action unless +15% tighten threshold ($65.04) is hit
- Capture EOD snapshots daily — do not skip even in low-activity sessions

### Overall Grade: B

---

## Week ending 2026-07-03

*Note: Market closed Fri Jul 3 (Independence Day observed; Jul 4 falls on Saturday). Last trading day was Thu Jul 2. Effective trading week: Jun 30–Jul 2 (3 trading days).*

### Stats
| Metric | Value |
|--------|-------|
| Starting portfolio | $100,000.00 |
| Ending portfolio | $101,047.42 |
| Week return | +$1,047.42 (+1.05%) |
| S&P 500 week | +1.80% |
| Bot vs S&P | -0.75% |
| Trades | 1 (W:0 / L:0 / open:1) |
| Win rate | N/A (no closed trades) |
| Best trade | MSFT +5.33% (unrealized) |
| Worst trade | MSFT +5.33% (only trade) |
| Profit factor | N/A (no closed trades) |

### Closed Trades
| Ticker | Entry | Exit | P&L | Notes |
|--------|-------|------|-----|-------|
| — | — | — | — | No closed trades this week |

### Open Positions at Week End
| Ticker | Entry | Close | Unrealized | Stop |
|--------|-------|-------|------------|------|
| MSFT | $370.73 | $390.49 | +$1,047.43 (+5.33%) | $352.98 (10% trail, HWM $392.20) |

### What Worked
- MSFT thesis (Azure/AI monetization) held through AVGO chip-sector selloff, NFP miss, and hawkish Fed signals
- Trailing stop GTC auto-advancing; position protected throughout (initial stop $333.91 → $352.98 by week end)
- Correctly avoided AVGO (source of chip-guidance miss) and NVDA (chip-sector headwind)
- Cash discipline on NFP print day + 3-day weekend: refused to force low-quality entries into a gap
- Research process correctly elevated MSFT as resilient vs. NVDA/AVGO within the AI thesis

### What Didn't Work
- Account deployed only 20.5% vs. 75-85% target — $80K+ in cash all week; largest single failure
- Planned 2-3 new positions after MSFT entry (every routine noted this) never materialized
- Zero sector diversification — missed the real YTD momentum leaders (Energy, Materials, Industrials)
- Every midday/pre-market routine deferred new entries to "next session"; that loop never closed

### Key Lessons
- Holiday-shortened weeks compress the window; must queue 2-3 candidates before Monday open, not after
- "Patience > activity" means waiting for the right setup, not waiting indefinitely — 20% deployed is not patience, it's inaction
- Tech (XLK) is a YTD lagging sector; MSFT is a single-name recovery/fundamentals play, not sector momentum — sizing should reflect that distinction
- NFP + 3-day weekend is a valid reason to skip entries on that day; it does not justify skipping entries for the whole week

### Adjustments for Next Week
- Jul 6 pre-market: research and enter 2-3 positions to close deployment gap (target 75-85%)
- Prioritize actual YTD momentum sectors: Materials, Industrials — individual names over ETFs where possible
- MSFT: hold with 10% trail; tighten to 7% when/if price hits $426.34 (+15%)
- Add deployment check to every midday scan: if <60% deployed and market is open, treat it as an action item, not a note

### Overall Grade: C