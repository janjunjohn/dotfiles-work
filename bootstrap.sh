#!/usr/bin/env bash
#
# bootstrap.sh — 会社 Mac mini 用ワンコマンドセットアップ。
#
#   git clone <repo> ~/dotfiles-work && cd ~/dotfiles-work && ./bootstrap.sh
#
# install(brew+ツール) -> link(symlink) -> macos(defaults) を順に実行。再実行OK。

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES

echo "════════════════════════════════════════════"
echo "  dotfiles-work bootstrap (会社 Mac mini)"
echo "  Source: $DOTFILES"
echo "════════════════════════════════════════════"

bash "$DOTFILES/scripts/install.sh"
bash "$DOTFILES/scripts/link.sh"
bash "$DOTFILES/scripts/macos.sh"

cat <<'EOF'

════════════════════════════════════════════
  bootstrap 完了。残りの手動ステップ:
════════════════════════════════════════════

  1. git の会社ID設定（重要・個人メールを使わない）:
       git config --global user.name  "Your Name"
       git config --global user.email "you@company.example"
     （または ~/.gitconfig の CHANGE_ME を書き換え）

  2. iTerm2: 起動 → Settings → Profiles → Colors → Color Presets →
     Import で iterm2/colors/color_for_Blue_One.itermcolors を読み込み、
     フォントを "SauceCodePro Nerd Font Mono" に設定。

  3. Karabiner-Elements: 初回起動で System Settings → Privacy & Security →
     Input Monitoring の権限を付与。

  4. 業務アプリ(Slack / Teams / Zoom 等)は会社IT/MDMの配布手順に従う。

  5. ログアウト/再起動でキーボード設定を完全反映。

EOF
