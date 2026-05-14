#!/usr/bin/env bash
set -euo pipefail

echo "╔══════════════════════════════════════╗"
echo "║       Litmus AI — Setup              ║"
echo "╚══════════════════════════════════════╝"
echo ""

# ── Check dependencies ─────────────────────────────────────────────────────
if ! command -v docker &>/dev/null; then
  echo "❌  Docker is not installed. Please install Docker Desktop first:"
  echo "    https://docs.docker.com/get-docker/"
  exit 1
fi

if ! docker compose version &>/dev/null; then
  echo "❌  Docker Compose v2 is required. Please update Docker Desktop."
  exit 1
fi

# ── Load existing .env if present ─────────────────────────────────────────
ENV_FILE="$(dirname "$0")/.env"
if [[ -f "$ENV_FILE" ]]; then
  echo "⚠️   .env already exists. Re-running setup will overwrite it."
  read -r -p "Continue? [y/N] " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }
fi

# ── Collect API key ────────────────────────────────────────────────────────
echo ""
read -r -p "Enter your OpenAI API key: " OPENAI_API_KEY
if [[ -z "$OPENAI_API_KEY" ]]; then
  echo "❌  OPENAI_API_KEY cannot be empty."
  exit 1
fi

# ── Optional overrides ─────────────────────────────────────────────────────
echo ""
echo "Optional overrides (press Enter to use defaults):"
read -r -p "  API port       [8000]: " API_PORT
read -r -p "  Dashboard port [3000]: " DASHBOARD_PORT
read -r -p "  Data directory [./data]: " LITMUS_DATA_DIR

API_PORT="${API_PORT:-8000}"
DASHBOARD_PORT="${DASHBOARD_PORT:-3000}"
LITMUS_DATA_DIR="${LITMUS_DATA_DIR:-./data}"

# Resolve LITMUS_DATA_DIR to an absolute host-side path so the SDK and the backend (in the container) read/write the same SQLite database file.
SETUP_DIR="$(cd "$(dirname "$0")" && pwd)"
case "$LITMUS_DATA_DIR" in
  /*) ABS_DATA_DIR="$LITMUS_DATA_DIR" ;;
  *)  ABS_DATA_DIR="$SETUP_DIR/${LITMUS_DATA_DIR#./}" ;;
esac
mkdir -p "$ABS_DATA_DIR"

HOST_DB_PATH="$ABS_DATA_DIR/litmus.db"
HOST_CHROMA_PATH="$ABS_DATA_DIR/chroma"

# ── Write .env ─────────────────────────────────────────────────────────────
cat > "$ENV_FILE" <<EOF
OPENAI_API_KEY=${OPENAI_API_KEY}
API_PORT=${API_PORT}
DASHBOARD_PORT=${DASHBOARD_PORT}
LITMUS_DATA_DIR=${LITMUS_DATA_DIR}

LITMUS_HOST_DB_PATH=${HOST_DB_PATH}
LITMUS_HOST_CHROMA_PATH=${HOST_CHROMA_PATH}
EOF

echo ""
echo "✅  .env written to $ENV_FILE"
echo "    host db    : $HOST_DB_PATH"
echo "    host chroma: $HOST_CHROMA_PATH"
echo ""
echo "Next steps:"
echo "  1. ./start.sh # boots backend + dashboard"
echo "  2. cd into your agent project"
echo "  3. Install litmus-sdk from pypi.
echo "  4. litmus init # auto-discovers paths from the backend"
echo ""
