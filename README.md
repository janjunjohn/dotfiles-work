# dotfiles-work

会社 Mac mini 用の最小 dotfiles。個人マシン用 `dotfiles` から **開発環境のコアだけ**を
抽出したもの。個人情報・個人ライセンス・個人アプリ・VPN・SSH鍵などは**一切含めない**。

## セットアップ（ワンコマンド）

```sh
git clone <this-repo> ~/dotfiles-work
cd ~/dotfiles-work
./bootstrap.sh
```

| ステップ | 内容 |
|---|---|
| install | Homebrew, `Brewfile`(CLI開発ツール + フォント + iTerm2/VSCode + VSCode拡張), oh-my-zsh + powerlevel10k + zsh-autosuggestions |
| link | 設定を symlink（既存ファイルは `*.backup` へ退避） |
| macos | キーボード設定のみ（キーリピート・タブ移動ショートカット） |

## 含まれるもの

```
home/     .zshrc .p10k.zsh .tmux.conf .gitconfig(会社IDは要設定)
config/   nvim tmux karabiner git
vscode/   settings.json keybindings.json extensions.txt
iterm2/   colors/(カラースキーム。プロファイルは手動import)
Brewfile  CLI開発ツール + フォント + iTerm2/VSCode + 拡張
scripts/  install.sh link.sh macos.sh
```

## 会社PCならではの注意

- **git の ID は会社用に設定**すること（`~/.gitconfig` の `CHANGE_ME`、または
  `git config --global user.email "you@company.example"`）。個人メールでコミットしない。
- **ユーザー名が `junkakishima` 以外の場合**: 設定内のパスは基本ポータブルだが、
  もし絶対パスを足す場合は新しいユーザー名に合わせること。
- Homebrew や各種設定が会社の **MDM 管理**と衝突しないか確認。`macos.sh` は
  キーボードまわりだけに絞ってある（トラックパッド/Dock 等は持ち込まない）。
- **GitHub Copilot 拡張**を含めている。会社方針で不可なら `Brewfile` の該当行を削除。

## キー配列は Karabiner 管理

Caps Lock → Control、Ctrl-`[` → Esc、fn+h/j/k/l → 矢印 は Karabiner-Elements
(`config/karabiner/karabiner.json`) が担当。`macos.sh` では Caps Lock を再マップしない。
