#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ ! -f "$SCRIPT_DIR/.env" ]]; then
  echo "❌  .env not found. Run ./setup.sh first."
  exit 1
fi

echo "🚀  Starting Litmus AI..."
docker compose --env-file "$SCRIPT_DIR/.env" -f "$SCRIPT_DIR/docker-compose.yml" up -d --pull always

echo ""
echo "✅  Litmus AI is running."

# Read ports from .env for display
source "$SCRIPT_DIR/.env"
API_PORT="${API_PORT:-8000}"
DASHBOARD_PORT="${DASHBOARD_PORT:-3000}"

echo "   Dashboard → http://localhost:${DASHBOARD_PORT}"
echo "   API       → http://localhost:${API_PORT}"
echo ""
echo "Next: in your agent project, run  litmus init  to wire the SDK to this backend."
