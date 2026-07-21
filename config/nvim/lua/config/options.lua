-- Loaded automatically before lazy.nvim starts.
-- LazyVim defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- fixed absolute line numbers (LazyVim defaults to relative/hybrid)
opt.number = true
opt.relativenumber = false

-- never conceal markdown syntax (LazyVim defaults to conceallevel=2, which hides
-- ``` fences etc. and re-reveals them on the cursor line, causing the text to
-- shift as you move around). 0 keeps everything shown as raw text.
opt.conceallevel = 0

-- 4-space indentation (LazyVim defaults to 2)
opt.shiftwidth = 4
opt.tabstop = 4
opt.expandtab = true
opt.autoindent = true

-- persistent undo across sessions
opt.undofile = true

-- use the macOS system clipboard as the default register
opt.clipboard = "unnamedplus"

vim.cmd("language en_US")
