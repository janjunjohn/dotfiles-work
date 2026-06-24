#!/usr/bin/env bash
#
# macos.sh — 会社 Mac mini 用の最小限の macOS 設定（人間工学まわりのみ）。
#
# 個人マシンの defaults をそのまま持ち込むと会社の MDM 管理設定と衝突しうるため、
# ここではキーボードまわり（タイピング効率に直結）だけに絞っている。
# 不要な行はコメントアウトすること。
#
# NOTE: Caps Lock -> Control は Karabiner が担当（config/karabiner/karabiner.json）。
#       ここでは再マップしない（二重remap防止）。

set -euo pipefail

echo "==> [macos] キーリピート速度"
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 9

echo "==> [macos] グローバルなタブ移動ショートカット（全アプリ）"
defaults write -g NSUserKeyEquivalents -dict-add "Show Next Tab"     '^n'
defaults write -g NSUserKeyEquivalents -dict-add "Show Previous Tab" '^p'

# 会社で MDM がトラックパッド/Dock 等を管理している場合があるため、
# それらは意図的に含めていない。必要なら個人 dotfiles の macos.sh を参照して追記。

echo "==> [macos] 完了。ログアウト/再起動で完全反映。"
