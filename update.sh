#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "⬇️   Pulling latest Litmus AI images..."
docker compose -f "$SCRIPT_DIR/docker-compose.yml" pull

echo "🔄  Restarting with new images..."
docker compose --env-file "$SCRIPT_DIR/.env" -f "$SCRIPT_DIR/docker-compose.yml" up -d

echo "✅  Update complete."
