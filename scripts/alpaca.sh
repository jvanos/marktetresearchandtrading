#!/usr/bin/env bash
# Alpaca API wrapper. All trading API calls go through here.
# Usage: bash scripts/alpaca.sh <subcommand> [args...]
#
# BUY orders are gated in code (not left to the calling prompt): no options,
# max 6 open positions, max 20% of equity per position, max 8 filled buys/week,
# cost <= live buying_power, and a daily-loss circuit breaker. The PDT
# day-trade-count rule is being phased out (SEC-approved Apr 2026, effective
# Jun 2026, brokerages have until Oct 2027 to fully implement) so this wrapper
# deliberately checks live `buying_power` instead of hardcoding a day-trade
# formula -- Alpaca computes that field correctly under whatever margin rules
# currently apply.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$ROOT/.env"

if [[ -f "$ENV_FILE" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
fi

: "${ALPACA_API_KEY:?ALPACA_API_KEY not set in environment}"
: "${ALPACA_SECRET_KEY:?ALPACA_SECRET_KEY not set in environment}"

API="${ALPACA_ENDPOINT:-https://api.alpaca.markets/v2}"
DATA="${ALPACA_DATA_ENDPOINT:-https://data.alpaca.markets/v2}"
MAX_DAILY_LOSS_PCT="${MAX_DAILY_LOSS_PCT:-0.05}"

H_KEY="APCA-API-KEY-ID: $ALPACA_API_KEY"
H_SEC="APCA-API-SECRET-KEY: $ALPACA_SECRET_KEY"

cmd="${1:-}"
shift || true

case "$cmd" in
  account)
    curl -fsS -H "$H_KEY" -H "$H_SEC" "$API/account"
    ;;
  positions)
    curl -fsS -H "$H_KEY" -H "$H_SEC" "$API/positions"
    ;;
  position)
    sym="${1:?usage: position SYM}"
    curl -fsS -H "$H_KEY" -H "$H_SEC" "$API/positions/$sym"
    ;;
  quote)
    sym="${1:?usage: quote SYM}"
    curl -fsS -H "$H_KEY" -H "$H_SEC" "$DATA/stocks/$sym/quotes/latest"
    ;;
  orders)
    status="${1:-open}"
    curl -fsS -H "$H_KEY" -H "$H_SEC" "$API/orders?status=$status"
    ;;
  clock)
    curl -fsS -H "$H_KEY" -H "$H_SEC" "$API/clock"
    ;;
  order)
    body="${1:?usage: order '<json>'}"
    side="$(python3 -c "import json,sys; print(json.loads(sys.argv[1]).get('side',''))" "$body")"
    symbol="$(python3 -c "import json,sys; print(json.loads(sys.argv[1]).get('symbol',''))" "$body")"

    if [[ "$side" == "buy" ]]; then
      # Cheapest check first, no network required: this wrapper has no code
      # path that can construct an options order, so reject anything that
      # isn't a plain equity ticker before making any API calls.
      if [[ ! "$symbol" =~ ^[A-Z]{1,5}$ ]]; then
        echo "ORDER REJECTED: symbol '$symbol' does not look like a plain equity ticker -- no options/derivatives through this wrapper" >&2
        exit 2
      fi

      account_json="$(curl -fsS -H "$H_KEY" -H "$H_SEC" "$API/account")"
      positions_json="$(curl -fsS -H "$H_KEY" -H "$H_SEC" "$API/positions")"
      monday="$(python3 -c "import datetime as d; t=d.date.today(); print(t - d.timedelta(days=t.weekday()))")"
      orders_json="$(curl -fsS -H "$H_KEY" -H "$H_SEC" "$API/orders?status=all&after=${monday}T00:00:00Z&direction=asc&limit=500")"
      quote_json="$(curl -fsS -H "$H_KEY" -H "$H_SEC" "$DATA/stocks/$symbol/quotes/latest" || echo '{}')"

      gate_result="$(python3 -c "
import json, sys, datetime

order, account, positions, orders, quote = (json.loads(a) for a in sys.argv[1:6])
max_daily_loss_pct = float(sys.argv[6])

symbol = order.get('symbol', '')
qty = float(order.get('qty', 0) or 0)

def reject(msg):
    print('REJECT: ' + msg)
    sys.exit(0)

equity = float(account.get('equity', 0))
cash = float(account.get('cash', 0))
buying_power = float(account.get('buying_power', 0))
last_equity = float(account.get('last_equity', 0))

held = {p['symbol'] for p in positions}
new_count = len(held) if symbol in held else len(held) + 1
if new_count > 6:
    reject(f'would result in {new_count} open positions, max is 6')

monday = (datetime.date.today() - datetime.timedelta(days=datetime.date.today().weekday())).isoformat()
week_buys = sum(
    1 for o in orders
    if o.get('side') == 'buy' and o.get('filled_at') and o['filled_at'][:10] >= monday
)
if week_buys >= 8:
    reject(f'already {week_buys} filled buy orders this week (Mon-today), max 8 new trades/week')

limit_price = order.get('limit_price')
price = float(limit_price) if limit_price else float(quote.get('quote', {}).get('ap', 0) or quote.get('quote', {}).get('bp', 0) or 0)
if price <= 0:
    reject('could not determine a price for cost checks (bad/halted quote)')

cost = qty * price

if cost > 0.20 * equity:
    reject(f'order cost ~\${cost:.2f} exceeds 20% of equity (\${equity:.2f})')
if cost > cash:
    reject(f'order cost ~\${cost:.2f} exceeds available cash (\${cash:.2f})')
if cost > buying_power:
    reject(f'order cost ~\${cost:.2f} exceeds live buying_power (\${buying_power:.2f})')

if last_equity > 0:
    loss_pct = (last_equity - equity) / last_equity
    if loss_pct >= max_daily_loss_pct:
        reject(f'daily loss circuit breaker tripped (down {loss_pct:.1%} from last close, threshold {max_daily_loss_pct:.0%}) -- no new buys until tomorrow')

print('OK')
" "$body" "$account_json" "$positions_json" "$orders_json" "$quote_json" "$MAX_DAILY_LOSS_PCT")"

      if [[ "$gate_result" != "OK" ]]; then
        echo "ORDER REJECTED: ${gate_result#REJECT: }" >&2
        exit 2
      fi
    fi

    curl -fsS -H "$H_KEY" -H "$H_SEC" -H "Content-Type: application/json" \
      -X POST -d "$body" "$API/orders"
    ;;
  cancel)
    oid="${1:?usage: cancel ORDER_ID}"
    curl -fsS -H "$H_KEY" -H "$H_SEC" -X DELETE "$API/orders/$oid"
    ;;
  cancel-all)
    curl -fsS -H "$H_KEY" -H "$H_SEC" -X DELETE "$API/orders"
    ;;
  close)
    sym="${1:?usage: close SYM}"
    # Alpaca reserves shares against open sell orders, so cancel the
    # symbol's open orders (e.g. its trailing stop) before closing --
    # closing first and cancelling after gets the close rejected.
    open_orders="$(curl -fsS -H "$H_KEY" -H "$H_SEC" "$API/orders?status=open&symbols=$sym")"
    echo "$open_orders" | python3 -c "
import json, sys
for o in json.load(sys.stdin):
    print(o['id'])
" | while read -r oid; do
      [[ -n "$oid" ]] && curl -fsS -H "$H_KEY" -H "$H_SEC" -X DELETE "$API/orders/$oid" >/dev/null
    done
    curl -fsS -H "$H_KEY" -H "$H_SEC" -X DELETE "$API/positions/$sym"
    ;;
  close-all)
    curl -fsS -H "$H_KEY" -H "$H_SEC" -X DELETE "$API/positions?cancel_orders=true"
    ;;
  *)
    echo "Usage: bash scripts/alpaca.sh <account|positions|position|quote|orders|clock|order|cancel|cancel-all|close|close-all> [args]" >&2
    exit 1
    ;;
esac
echo