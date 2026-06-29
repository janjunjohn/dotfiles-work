# Brewfile — 会社 Mac mini 用（開発環境コアのみ）
#
# 方針:
#  - 業務アプリ(Slack / Teams / Zoom)は会社IT配布のため含めない
#  - 個人アプリ(Anki / Discord / iStat / Surfshark など)は含めない
#  - 開発に必要な CLI ツール・フォント・エディタ/ターミナルのみ
#
# 不要な行はコメントアウトして調整してください。

# 信頼できないサードパーティ tap は新しい Homebrew で "untrusted" 扱いとなり
# bundle が止まるため無効化（必要なら `brew trust daipeihust/tap` の上で再有効化）。
# tap "daipeihust/tap"

# --- CLI / 開発ツール ---
brew "neovim"
brew "tmux"
brew "fzf"
brew "autojump"
# IME 切替（nvim/vim の自動 IME 切替に使用）。daipeihust/tap 無効化に伴いコメント化。
# nvim の IME ガード（config/nvim/lua/config/autocmds.lua）は im-select 不在でも
# `executable("im-select")` で無害にスキップされる。必要時は tap を信頼の上で再有効化。
# brew "daipeihust/tap/im-select"
# 検索・ファイル探索
brew "ripgrep"
brew "fd"
# Git 補助
brew "lazygit"
brew "git-delta"
brew "gh"
# リモートシェル
brew "mosh"

# --- 言語バージョン管理（必要なものだけ残す） ---
brew "pyenv"
brew "poetry"
brew "rbenv"
brew "ruby-build"
brew "nodebrew"
brew "yarn"
brew "tcl-tk"

# --- ローカルDB（会社で使うなら有効化。不要ならコメントアウトのまま） ---
# brew "postgresql@17"
# brew "mariadb"

# --- エディタ / ターミナル / ランチャー ---
cask "iterm2"
cask "visual-studio-code"
cask "raycast"
# キー配列管理（config/karabiner/ を読み込む）
cask "karabiner-elements"
# Claude Code はネイティブインストーラ版（~/.local/bin/claude）に一本化。
# brew cask では管理しない（scripts/install.sh が curl で冪等導入する）。
# cask "claude-code"

# --- フォント（p10k / ターミナルのグリフに必須） ---
cask "font-sauce-code-pro-nerd-font"
cask "font-source-code-pro"
cask "font-meslo-lg-nerd-font"

# --- VSCode 拡張（開発系。会社方針で不要なものは削除） ---
vscode "asvetliakov.vscode-neovim"
vscode "bierner.markdown-preview-github-styles"
vscode "eamodio.gitlens"
# Copilot は VSCode 1.126+ に同梱され、拡張版と衝突するため無効化。
# 会社方針で利用可なら同梱版をそのまま使用（個別インストール不要）。
# vscode "github.copilot"
# vscode "github.copilot-chat"
vscode "humao.rest-client"
vscode "ms-azuretools.vscode-docker"
vscode "ms-python.debugpy"
vscode "ms-python.flake8"
vscode "ms-python.mypy-type-checker"
vscode "ms-python.python"
vscode "ms-python.vscode-pylance"
vscode "streetsidesoftware.code-spell-checker"
vscode "sdras.night-owl"
