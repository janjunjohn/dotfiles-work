-- Loaded on the VeryLazy event.
-- LazyVim defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local keymap = vim.keymap

-- delete a single char without overwriting the yank register
keymap.set("n", "x", '"_x')

-- save the current file and run it with python
keymap.set("n", "ss", ":w | !python %<CR>", { desc = "Run file with python" })
