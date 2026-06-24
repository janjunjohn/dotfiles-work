local opt = vim.opt -- for conciseness

-- line numbers
opt.number = true -- shows absolute line number

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- text format
opt.shiftwidth = 4
opt.tabstop = 4
opt.expandtab = true
opt.textwidth = 0
opt.autoindent = true
opt.undofile = true

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    os.execute("im-select com.apple.keylayout.ABC")
  end,
})
