# Brewfile — 会社 Mac mini 用（開発環境コアのみ）
#
# 方針:
#  - 業務アプリ(Slack / Teams / Zoom)は会社IT配布のため含めない
#  - 個人アプリ(Anki / Discord / iStat / Surfshark など)は含めない
#  - 開発に必要な CLI ツール・フォント・エディタ/ターミナルのみ
#
# 不要な行はコメントアウトして調整してください。

tap "daipeihust/tap"

# --- CLI / 開発ツール ---
brew "neovim"
brew "tmux"
brew "fzf"
brew "autojump"
# IME 切替（nvim/vim の自動 IME 切替に使用）
brew "daipeihust/tap/im-select"

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

# --- フォント（p10k / ターミナルのグリフに必須） ---
cask "font-sauce-code-pro-nerd-font"
cask "font-source-code-pro"
cask "font-meslo-lg-nerd-font"

# --- VSCode 拡張（開発系。会社方針で不要なものは削除） ---
vscode "asvetliakov.vscode-neovim"
vscode "bierner.markdown-preview-github-styles"
vscode "eamodio.gitlens"
vscode "github.copilot"
vscode "github.copilot-chat"
vscode "humao.rest-client"
vscode "ms-azuretools.vscode-docker"
vscode "ms-python.debugpy"
vscode "ms-python.flake8"
vscode "ms-python.mypy-type-checker"
vscode "ms-python.python"
vscode "ms-python.vscode-pylance"
vscode "streetsidesoftware.code-spell-checker"
vscode "sdras.night-owl"
