---
name: intranet-browser
description: Reliably access intranet web pages with agent-browser on a Windows corporate-internal-network machine (internal wikis, doc portals, internal apps behind the corporate VPN). Use this skill whenever the user asks to visit an intranet address, scrape intranet wiki/doc/web content, or automate an internal site — even when they do not explicitly say "intranet". Also use it immediately for troubleshooting whenever agent-browser prints "relaunched browser", "Chrome exited early", "DevToolsActivePort", or "EOF while parsing" (browser repeatedly crashing or the daemon being unresponsive). Core approach: launch the system-installed Chrome with a CDP remote-debugging port, then drive it via `agent-browser --cdp`.
---

# intranet-browser — agent-browser access on a corporate intranet

## Why this skill exists

On Windows machines running corporate security software, the Chromium that
agent-browser bundles (located in the non-standard `~/.agent-browser/browsers/`
directory) gets silently killed right after launch. Typical symptoms:

- `Chrome exited early (exit code: 0) without writing DevToolsActivePort`
- every command prints `[agent-browser] relaunched browser`, and page state is
  lost between commands
- `open` reports success, but the very next `get url` returns `about:blank` and
  `snapshot` comes back empty
- the daemon reports `Invalid response: EOF while parsing a value`

A plain `agent-browser open` is unreliable in this environment. **The fix**:
do not let agent-browser's daemon own the browser lifecycle — launch the
system-installed Chrome yourself (it lives in a standard directory, is signed,
and the security software allows it) with a CDP remote-debugging port, then
point every agent-browser command at that external browser via `--cdp`.

## Standard workflow

### Step 1 — make sure system Chrome is running in CDP mode

Run the idempotent helper script bundled with this skill (it reuses an
already-running instance and never launches a duplicate):

```bash
bash "<this-skill-dir>/scripts/ensure-chrome-cdp.sh"        # default port 9222
bash "<this-skill-dir>/scripts/ensure-chrome-cdp.sh" 9223   # alternate port when you need isolation
```

The script does three things: probes whether a CDP service is already on the
port → locates the system Chrome → launches it with a dedicated user-data-dir
(`~/.agent-browser/cdp-profile`, kept separate from the user's everyday Chrome
so the two never collide) and waits for the port to come up.

Equivalent manual commands, if the script is unavailable:

```bash
"/c/Program Files/Google/Chrome/Application/chrome.exe" \
  --remote-debugging-port=9222 \
  --user-data-dir="$USERPROFILE\\.agent-browser\\cdp-profile" \
  --no-first-run --no-default-browser-check about:blank &
sleep 5
curl -s http://127.0.0.1:9222/json/version   # JSON output means it is ready
```

The dedicated user-data-dir is mandatory. If you reuse the everyday Chrome's
default profile while everyday Chrome is already running, the new process just
hands the URL off to the existing instance and exits (exit 0) — the CDP port
never opens.

### Step 2 — append `--cdp 9222` to every command

This is the easiest step to forget: **any single** command without `--cdp`
makes the daemon try to launch the bundled Chrome again, restarting the crash
loop.

```bash
agent-browser --cdp 9222 open "https://<intranet-host>/<path>"
agent-browser --cdp 9222 wait --load networkidle
agent-browser --cdp 9222 get title
```

### Step 3 — read or interact

```bash
# Pull the body text (markdown-friendly, good for wiki/doc pages); write to a
# file so a long page does not flood the terminal.
agent-browser --cdp 9222 read > /tmp/page_content.txt

# Inspect interactive elements (login fields, buttons, sidebar trees, etc.)
agent-browser --cdp 9222 snapshot -i -c

# After an interaction the page changes and refs go stale — re-snapshot.
agent-browser --cdp 9222 click @e5
agent-browser --cdp 9222 wait --load networkidle
agent-browser --cdp 9222 snapshot -i -c
```

Intranet SPAs are often slow to render. After `open`, always run
`wait --load networkidle` before reading — otherwise the snapshot can be empty.

## SSO / login handling

The Chrome started via CDP is **a visible window**. If the snapshot shows a
corporate SSO login page, do not attempt to autofill credentials — ask the
user to complete the login in the Chrome window that popped up, then continue.
The logged-in state persists in the `cdp-profile` directory, so later sessions
that reuse the same user-data-dir stay logged in.

How to tell you are already logged in: the snapshot contains elements such as
the user's display name, a logout link, or a dashboard/workbench entry.

## Troubleshooting cheat sheet

| Symptom | Fix |
|---------|-----|
| `EOF while parsing a value` (daemon unresponsive) | `agent-browser close --all`, then retry |
| `relaunched browser` / `Chrome exited early` | `--cdp` was omitted — go back to steps 1 and 2 |
| empty snapshot / `about:blank` | page not done loading — `wait --load networkidle` and retry; if still empty, confirm you are using `--cdp` |
| intranet certificate error | add the global flag `--ignore-https-errors` |
| port 9222 taken by something other than Chrome | switch ports — pass `9223` to the script and use `--cdp 9223` thereafter |
| `click` reports it is covered by an overlay (e.g. an embedded support/chatbot widget drawer) | bypass it by running a JS click on the target via `agent-browser --cdp 9222 eval`, or remove the overlay with JS first |
| need to toggle between proxy and direct | `--proxy <url>` / `--proxy-bypass "<intranet-domain>"` |

## Cleanup

When a task is done, the CDP Chrome can be left running (next time it needs no
launch and no login). Only when the user explicitly asks to clean up:

```bash
agent-browser close --all
# The Chrome window is left for the user to close, or: taskkill //IM chrome.exe //F
# (this kills every Chrome process — use with care)
```
