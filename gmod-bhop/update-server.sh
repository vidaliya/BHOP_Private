#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STEAMCMD_DIR="$ROOT_DIR/steamcmd"
SERVER_DIR="$ROOT_DIR/server"
STEAMCMD_BIN="$STEAMCMD_DIR/steamcmd.sh"

mkdir -p "$STEAMCMD_DIR" "$SERVER_DIR"

if [[ ! -x "$STEAMCMD_BIN" ]]; then
  echo "[INFO] steamcmd not found. Bootstrapping SteamCMD..."
  curl -fsSL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" -o "$STEAMCMD_DIR/steamcmd_linux.tar.gz"
  tar -xzf "$STEAMCMD_DIR/steamcmd_linux.tar.gz" -C "$STEAMCMD_DIR"
fi

echo "[INFO] Updating Garry's Mod dedicated server (app 4020)..."
"$STEAMCMD_BIN" \
  +force_install_dir "$SERVER_DIR" \
  +login anonymous \
  +app_update 4020 validate \
  +quit

echo "[OK] Update complete: $SERVER_DIR"
