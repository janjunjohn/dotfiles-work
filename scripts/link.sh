#!/usr/bin/env bash
#
# link.sh — symlink every tracked config from this repo to where each app reads it.
#
# Existing real files are moved aside to <file>.backup before linking.
# Re-running is safe: correct symlinks are left untouched.

set -euo pipefail

DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

link() {
  local src="$1" dst="$2"
  if [ ! -e "$src" ]; then
    echo "    !! source missing, skipping: $src"
    return
  fi
  mkdir -p "$(dirname "$dst")"
  # Already the correct symlink? Nothing to do.
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "    ok   $dst"
    return
  fi
  # Real file/dir in the way -> back it up.
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    echo "    bak  $dst -> $dst.backup"
    rm -rf "$dst.backup"
    mv "$dst" "$dst.backup"
  fi
  ln -s "$src" "$dst"
  echo "    link $dst -> $src"
}

echo "==> [link] home dotfiles"
link "$DOTFILES/home/.zshrc"     "$HOME/.zshrc"
link "$DOTFILES/home/.p10k.zsh"  "$HOME/.p10k.zsh"
link "$DOTFILES/home/.gitconfig" "$HOME/.gitconfig"

# tmux 3.x auto-loads ~/.config/tmux/tmux.conf (XDG). An additional ~/.tmux.conf
# that sources it makes the config run TWICE (duplicate binds / tpm init). So we
# intentionally do NOT create ~/.tmux.conf, and remove a stale one left by older
# setups so the next tmux start is a single, clean load.
if [ -e "$HOME/.tmux.conf" ] || [ -L "$HOME/.tmux.conf" ]; then
  echo "    rm   stale ~/.tmux.conf (tmux reads ~/.config/tmux/tmux.conf directly)"
  rm -f "$HOME/.tmux.conf"
fi

echo "==> [link] ~/.config apps"
link "$DOTFILES/config/nvim"      "$HOME/.config/nvim"
link "$DOTFILES/config/tmux"      "$HOME/.config/tmux"
link "$DOTFILES/config/karabiner" "$HOME/.config/karabiner"
link "$DOTFILES/config/git"       "$HOME/.config/git"

echo "==> [link] LaunchAgents (no-sleep + tmux auto-start)"
link "$DOTFILES/config/launchd/com.jun.caffeinate.plist" "$HOME/Library/LaunchAgents/com.jun.caffeinate.plist"
link "$DOTFILES/config/launchd/com.jun.tmux-dev.plist"   "$HOME/Library/LaunchAgents/com.jun.tmux-dev.plist"

echo "==> [link] Claude Code settings"
link "$DOTFILES/config/claude/settings.json" "$HOME/.claude/settings.json"

echo "==> [link] VSCode user settings"
VSC="$HOME/Library/Application Support/Code/User"
link "$DOTFILES/vscode/settings.json"    "$VSC/settings.json"
link "$DOTFILES/vscode/keybindings.json" "$VSC/keybindings.json"
if [ -d "$DOTFILES/vscode/snippets" ]; then
  link "$DOTFILES/vscode/snippets" "$VSC/snippets"
fi

echo "==> [link] done."
