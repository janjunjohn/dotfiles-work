#!/usr/bin/env bash
#
# install.sh — install Homebrew, all packages/casks/VSCode extensions (Brewfile),
# oh-my-zsh and its third-party theme/plugins.
#
# Idempotent: skips anything already present.

set -euo pipefail

DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

echo "==> [install] Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Make brew available in this shell (Apple Silicon path).
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  echo "    Homebrew already installed."
fi

echo "==> [install] brew bundle (formulae, casks, VSCode extensions)"
# Brewfile contains taps, brews, casks AND `vscode "..."` lines, so this also
# installs every VSCode extension (requires VSCode's `code` CLI, installed by the cask).
brew bundle --file="$DOTFILES/Brewfile" || {
  echo "    brew bundle reported errors (often a cask needing a re-run). Retrying once..."
  brew bundle --file="$DOTFILES/Brewfile"
}

echo "==> [install] oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes CHSH=no \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "    oh-my-zsh already installed."
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "==> [install] powerlevel10k theme"
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
else
  echo "    powerlevel10k already present."
fi

echo "==> [install] zsh-autosuggestions plugin"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "    zsh-autosuggestions already present."
fi

# fzf shell keybindings/completion (binary installed via Brewfile).
if command -v fzf >/dev/null 2>&1 && [ ! -f "$HOME/.fzf.zsh" ]; then
  echo "==> [install] fzf shell integration"
  "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish || true
fi

echo "==> [install] make default shell zsh"
if [ "${SHELL:-}" != "$(command -v zsh)" ]; then
  echo "    (You may be prompted for your password to chsh to zsh.)"
  chsh -s "$(command -v zsh)" || echo "    chsh skipped; change your login shell manually if needed."
fi

echo "==> [install] done."
