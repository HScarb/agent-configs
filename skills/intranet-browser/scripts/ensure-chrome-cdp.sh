#!/usr/bin/env bash
# ensure-chrome-cdp.sh — make sure system Chrome is running in CDP debug mode (idempotent)
# Usage: bash ensure-chrome-cdp.sh [port]   default port 9222
set -u

PORT="${1:-9222}"
CDP_URL="http://127.0.0.1:${PORT}/json/version"

# Reuse an existing CDP service if one is already up.
if curl -s --max-time 3 "$CDP_URL" | grep -q '"Browser"'; then
  echo "OK: Chrome CDP already running on port ${PORT}"
  curl -s --max-time 3 "$CDP_URL" | head -3
  exit 0
fi

# Locate the system-installed Chrome (standard directory, allowed by security software).
CHROME=""
for p in \
  "/c/Program Files/Google/Chrome/Application/chrome.exe" \
  "/c/Program Files (x86)/Google/Chrome/Application/chrome.exe" \
  "${LOCALAPPDATA:-}/Google/Chrome/Application/chrome.exe"; do
  if [ -f "$p" ]; then
    CHROME="$p"
    break
  fi
done

if [ -z "$CHROME" ]; then
  echo "ERROR: system-installed Chrome not found, please confirm it is installed" >&2
  exit 1
fi

# Dedicated user-data-dir: prevents the new process from handing the URL off to
# the everyday Chrome instance (which would make it exit immediately with code 0).
# USERPROFILE is a Windows-style path (C:\Users\xxx) under Git Bash, which is what Chrome expects.
PROFILE_DIR="${USERPROFILE:-$HOME}\\.agent-browser\\cdp-profile"

"$CHROME" \
  --remote-debugging-port="$PORT" \
  --user-data-dir="$PROFILE_DIR" \
  --no-first-run \
  --no-default-browser-check \
  about:blank &

# Wait for the CDP port to come up (up to 20 seconds).
for _ in $(seq 1 20); do
  sleep 1
  if curl -s --max-time 2 "$CDP_URL" | grep -q '"Browser"'; then
    echo "OK: Chrome CDP started on port ${PORT}"
    echo "For all subsequent commands use: agent-browser --cdp ${PORT} <command>"
    exit 0
  fi
done

echo "ERROR: port ${PORT} did not come up after Chrome launched. It may be blocked by security software or already in use." >&2
echo "Debug: curl -s ${CDP_URL} ; netstat -ano | grep ${PORT}" >&2
exit 1
