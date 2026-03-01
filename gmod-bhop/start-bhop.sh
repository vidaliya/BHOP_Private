#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVER_DIR="$ROOT_DIR/server"

# Update before launch
"$ROOT_DIR/update-server.sh"

cd "$SERVER_DIR"

exec ./srcds_run \
  -game garrysmod \
  +maxplayers 8 \
  +map bhop_badges \
  +host_workshop_collection 0 \
  +gamemode bhop \
  -tickrate 100 \
  -port 27015 \
  -console
