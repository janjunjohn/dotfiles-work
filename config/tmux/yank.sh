#!/usr/bin/env bash
# yank.sh — copy the tmux copy-mode selection (piped on stdin) to the LOCAL
# clipboard, even when invoked from inside a `display-popup` over SSH.
#
# Why this exists:
#   The claude session (prefix + y) is opened with
#     display-popup -E "tmux attach-session …"
#   i.e. a nested tmux client inside a popup. tmux does NOT forward an OSC 52
#   clipboard escape emitted inside a popup out to the real terminal, so the
#   usual `set-clipboard on` path silently dies there. Over SSH that path is
#   the only way to reach the local Mac (pbcopy only hits the remote pasteboard).
#
#   This script sidesteps the popup entirely: it writes the OSC 52 sequence
#   DIRECTLY to the real outer client's terminal device, which the local
#   terminal (iTerm etc.) honors. It also runs pbcopy so a purely local tmux
#   (no SSH) keeps working.
set -uo pipefail

data="$(cat)"

# 1) Local pasteboard — useful when tmux runs directly on this Mac. Over SSH
#    this only sets the remote machine's clipboard, which is why we also do (2).
if command -v pbcopy >/dev/null 2>&1; then
  printf '%s' "$data" | pbcopy
fi

# 2) OSC 52 written straight to the real terminal(s), bypassing the popup.
#    We write to the actual client tty (not through tmux), so a plain OSC 52
#    is correct here — no tmux DCS passthrough wrapping is needed.
b64="$(printf '%s' "$data" | base64 | tr -d '\r\n')"
seq="$(printf '\033]52;c;%s\a' "$b64")"

# Prefer clients that are NOT the claude popup itself — those ttys are the real
# local terminals. Fall back to every attached client if none match.
prefix="$(tmux show-option -gqv @claude_session_prefix 2>/dev/null)"
[ -n "$prefix" ] || prefix="claude-"

ttys="$(tmux list-clients -F '#{client_session}	#{client_tty}' 2>/dev/null \
        | awk -F'\t' -v p="$prefix" 'index($1, p) != 1 { print $2 }')"
[ -n "$ttys" ] || ttys="$(tmux list-clients -F '#{client_tty}' 2>/dev/null)"

while IFS= read -r tty; do
  [ -n "$tty" ] && [ -w "$tty" ] && printf '%s' "$seq" >"$tty" 2>/dev/null
done <<EOF
$ttys
EOF
