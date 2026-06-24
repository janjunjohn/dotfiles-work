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
link "$DOTFILES/home/.tmux.conf" "$HOME/.tmux.conf"
link "$DOTFILES/home/.gitconfig" "$HOME/.gitconfig"

echo "==> [link] ~/.config apps"
link "$DOTFILES/config/nvim"      "$HOME/.config/nvim"
link "$DOTFILES/config/tmux"      "$HOME/.config/tmux"
link "$DOTFILES/config/karabiner" "$HOME/.config/karabiner"
link "$DOTFILES/config/git"       "$HOME/.config/git"

echo "==> [link] VSCode user settings"
VSC="$HOME/Library/Application Support/Code/User"
link "$DOTFILES/vscode/settings.json"    "$VSC/settings.json"
link "$DOTFILES/vscode/keybindings.json" "$VSC/keybindings.json"
if [ -d "$DOTFILES/vscode/snippets" ]; then
  link "$DOTFILES/vscode/snippets" "$VSC/snippets"
fi

echo "==> [link] done."
