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
home/     .zshrc .p10k.zsh .gitconfig(会社IDは要設定)
config/   nvim(LazyVim) tmux karabiner git claude launchd
vscode/   settings.json keybindings.json extensions.txt
iterm2/   colors/(カラースキーム。プロファイルは手動import)
Brewfile  CLI開発ツール + フォント + iTerm2/VSCode + 拡張
scripts/  install.sh link.sh macos.sh setup-tmux.sh
```

> tmux は `~/.tmux.conf` を**作らない**。tmux 3.x は `~/.config/tmux/tmux.conf` を
> XDG 経由で直接読むため、`~/.tmux.conf`（→ source）を併存させると設定が二重実行され
> bind / tpm が壊れる。`link.sh` は stale な `~/.tmux.conf` を自動削除する。
> tmux 環境（tpm + プラグイン + launchd）は `scripts/setup-tmux.sh` で構築する。

> Claude Code CLI は **ネイティブ版（`~/.local/bin/claude`）に一本化**。brew cask では
> 管理せず、`install.sh` が未導入時のみ `https://claude.ai/install.sh` で冪等導入する。

## 既存環境の更新（pull 側 PC ＝ 会社 Mac mini）

設定変更は別 PC でコミット／push され、会社 Mac mini は **pull するだけ**の運用。
`git pull` 後、コミットだけでは反映されない以下の作業を手元で実施する（すべて再実行安全）。

```sh
cd ~/dotfiles-work
git pull

# 1) 再リンク（stale な ~/.tmux.conf 削除・launchd/claude 設定の貼り直し）
bash scripts/link.sh

# 2) Claude Code ネイティブ版の導入（未導入時のみ。install.sh でも自動実行される）
command -v claude >/dev/null || curl -fsSL https://claude.ai/install.sh | bash

# 3) 変更した launchd エージェント（tmux-dev: PATH 追加）の再読込
launchctl unload ~/Library/LaunchAgents/com.jun.tmux-dev.plist 2>/dev/null
launchctl load   ~/Library/LaunchAgents/com.jun.tmux-dev.plist

# 4) tmux 環境の再構築（tpm + プラグイン取得。設定 source 順の修正込み）
bash scripts/setup-tmux.sh

# 5) nvim プラグインをロックファイルに合わせる
#    nvim を開いて :Lazy restore（lazy-lock.json のコミット版に固定）
#    未取得プラグインがあれば :Lazy sync
nvim
```

### 反映後の動作確認

```sh
# tmux 設定が単一読み込みか（1 が正常。2 以上は二重読み込み再発）
tmux list-keys | grep -c 'Reloaded'

# ~/.tmux.conf が再生成されていないこと（"No such file" が正常）
ls -la ~/.tmux.conf
```

- tmux 内で `prefix + y` → claude セッション起動、`prefix + g` → lazygit popup。
- `prefix + u` → 実行中 claude セッションの working / waiting / idle ステータス表示。
- ⚠️ `tmux kill-server` は全セッションを落とすので、実行は必ず tmux の**外**の端末から。

> **nvim の `lazy-lock.json` について**: これは生成物。リポジトリのコミット版を「正」とし、
> 各マシンでは `:Lazy restore` で同一バージョンに揃える。実機で `:Lazy sync` 等により
> 内容が変わっても、原則このリポジトリのロックファイルに合わせる（機械的な上書き commit はしない）。

## 会社PCならではの注意

- **git の ID は会社用に設定**すること（`~/.gitconfig` の `CHANGE_ME`、または
  `git config --global user.email "you@company.example"`）。個人メールでコミットしない。
- **ユーザー名が `junkakishima` 以外の場合**: 設定内のパスは基本ポータブルだが、
  もし絶対パスを足す場合は新しいユーザー名に合わせること。
- Homebrew や各種設定が会社の **MDM 管理**と衝突しないか確認。`macos.sh` は
  キーボードまわりだけに絞ってある（トラックパッド/Dock 等は持ち込まない）。
- **GitHub Copilot 拡張**は VSCode 1.126+ に同梱されるため `Brewfile` ではコメント化済み
  （同梱版と個別拡張の衝突回避）。会社方針で利用可なら同梱版をそのまま使う。
- **Karabiner-Elements** は `Brewfile` の cask で導入する（`config/karabiner/` を読み込む）。

## キー配列は Karabiner 管理

Caps Lock → Control、Ctrl-`[` → Esc、fn+h/j/k/l → 矢印 は Karabiner-Elements
(`config/karabiner/karabiner.json`) が担当。`macos.sh` では Caps Lock を再マップしない。
