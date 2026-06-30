# Trading Bot

An autonomous Claude Code agent that manages a stock-only swing-trading
account on Alpaca. There is no separate bot process — Claude itself is the
bot, invoked fresh on a schedule. Git is its only memory between runs (see
`memory/`); the only way it ever touches money is through
`scripts/alpaca.sh`.

Paper trading by default. See `env.template` before flipping to live.

## Quickstart (local)

1. `cp env.template .env` and fill in real credentials. `.env` is
   gitignored — never commit it.
2. Sign up for Alpaca (paper is fine to start), Perplexity, and ClickUp.
   Create a ClickUp chat channel for notifications and note its workspace
   ID and channel ID.
3. Open this repo in Claude Code and run `/portfolio`. You should see your
   account and positions print cleanly with no errors.
4. The other local commands — `/pre-market`, `/market-open`, `/midday`,
   `/daily-summary`, `/weekly-review`, `/trade` — are in
   `.claude/commands/` for manual/ad-hoc use.

## Safety mechanisms

This repo enforces its hard trading rules in code, not just in prompts:

- **`scripts/alpaca.sh order` validates every BUY before it reaches
  Alpaca** — no options, max 6 open positions, max 20% of equity per
  position, max 3 filled buys/week, cost must not exceed live
  `buying_power`, and a daily-loss circuit breaker (`MAX_DAILY_LOSS_PCT` in
  `.env`, default 5%) blocks new buys after a bad day. Sells/closes are
  never blocked. A rejected order exits with code 2 and a reason on
  stderr — that's the bot's actual backstop against a bad prompt or
  poisoned research, not the strategy doc.
- **`HALT` file** — commit an empty file named `HALT` to the repo root to
  pause every routine immediately; delete it to resume. See
  `routines/README.md`.
- **Market clock check** — every routine calls `scripts/alpaca.sh clock`
  first and exits without trading if the market is closed (covers
  holidays the cron schedule doesn't know about).
- **Strategy changes require a human** — the weekly-review workflow can
  propose changes to `memory/TRADING-STRATEGY.md` but never edits it
  directly, and the hard limits above live in the wrapper script, not a
  memory file a bad week could talk the bot into loosening.

See `CLAUDE.md` for the full rule set and `memory/TRADING-STRATEGY.md` for
the strategy itself.

## Cloud routines (production path)

Five scheduled cloud runs do the actual trading: pre-market research,
market-open execution, a midday risk scan, a daily summary, and a Friday
weekly review. Setting these up requires the Claude Code web UI (install
the GitHub App, create five routines, paste in the prompts from
`routines/*.md`, set environment variables on each routine — never a
`.env` file in the cloud). Full instructions: `routines/README.md`.

## Layout

```
CLAUDE.md          Agent rulebook, auto-loaded every session
env.template        Copy to .env locally; never commit .env
.claude/commands/    Local slash commands (manual/ad-hoc use)
routines/            Cloud routine prompts (the production path)
scripts/             alpaca.sh / perplexity.sh / clickup.sh wrappers —
                      the only way this repo touches the outside world
memory/              The bot's persistent state, committed to main
```
