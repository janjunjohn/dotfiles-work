#!/usr/bin/env bash
#
# setup-tmux.sh — tmux 環境のセットアップ専用スクリプト
#
# bootstrap.sh / install.sh + link.sh を実行済みの環境でも安全に再実行できる。
# tpm のインストール → プラグイン取得 → launchd エージェント登録 の3ステップを担当。
#
# 前提: tmux が Homebrew でインストール済みであること (brew install tmux)。

set -euo pipefail

DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

# Homebrew の tmux を PATH に乗せる
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if ! command -v tmux >/dev/null 2>&1; then
  echo "!! tmux が見つかりません。先に 'brew install tmux' を実行してください。"
  exit 1
fi

# ── 1. tpm (tmux plugin manager) ──────────────────────────────────────────────
echo "==> [tmux] tpm のインストール"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  echo "    tpm をクローンしました。"
else
  echo "    tpm は既に存在します。"
fi

# ── 2. config/tmux を ~/.config/tmux へシンボリックリンク ──────────────────────
echo "==> [tmux] ~/.config/tmux のリンク"
link() {
  local src="$1" dst="$2"
  if [ ! -e "$src" ]; then
    echo "    !! source missing, skipping: $src"
    return
  fi
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "    ok   $dst"
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    echo "    bak  $dst -> $dst.backup"
    rm -rf "$dst.backup"
    mv "$dst" "$dst.backup"
  fi
  ln -s "$src" "$dst"
  echo "    link $dst -> $src"
}

link "$DOTFILES/config/tmux" "$HOME/.config/tmux"

# ── 3. launchd エージェントの登録 ──────────────────────────────────────────────
echo "==> [tmux] launchd エージェントのリンクと登録"

register_agent() {
  local plist_name="$1"
  local src="$DOTFILES/config/launchd/$plist_name"
  local dst="$HOME/Library/LaunchAgents/$plist_name"

  link "$src" "$dst"

  # 既にロード済みか確認してから launchctl load
  if launchctl list | grep -q "${plist_name%.plist}"; then
    echo "    already loaded: ${plist_name%.plist}"
  else
    launchctl load "$dst"
    echo "    loaded: $dst"
  fi
}

register_agent "com.jun.caffeinate.plist"
register_agent "com.jun.tmux-dev.plist"

# ── 4. tpm プラグインの自動インストール ────────────────────────────────────────
echo "==> [tmux] tpm プラグインのインストール (tmux-resurrect, tmux-continuum, tmux-claude-session-manager)"
TPM_INSTALL="$HOME/.tmux/plugins/tpm/bin/install_plugins"
if [ -x "$TPM_INSTALL" ]; then
  # TMUX 環境変数がない場合 (tmux セッション外) は tpm スクリプトを直接呼ぶ
  if [ -z "${TMUX:-}" ]; then
    # tpm の install_plugins は tmux サーバーが起動している必要がある
    if tmux start-server \; run-shell "$TPM_INSTALL" 2>/dev/null; then
      echo "    プラグインをインストールしました。"
    else
      echo "    !! tpm 自動インストールに失敗しました。"
      echo "    tmux を起動して 'prefix + I' を押してプラグインを手動インストールしてください。"
    fi
  else
    "$TPM_INSTALL"
    echo "    プラグインをインストールしました。"
  fi
else
  echo "    !! tpm の install_plugins が見つかりません。"
  echo "    tmux を起動して 'prefix + I' を押してプラグインを手動インストールしてください。"
fi

echo ""
echo "==> [tmux] セットアップ完了!"
echo "    次のステップ:"
echo "    1. 新しいターミナルで 'tmux' を起動 (または 'tmux attach -t dev')"
echo "    2. プラグインが正常にロードされているか確認 (prefix + I で再インストール可)"
echo "    3. Claude Code を起動して prefix + y / prefix + u が動作するか確認"
