#!/usr/bin/env bash
# Engram re-anchor hook: surfaces due reviews at session start.
# Prints at most two lines (or nothing) — ambient, never nagging (Constitution art. 8).
# Must never break a session: degrade to silence on any failure.
set -u
command -v python3 >/dev/null 2>&1 || exit 0
python3 "${CLAUDE_PLUGIN_ROOT}/scripts/engram.py" session-start 2>/dev/null || true
exit 0
