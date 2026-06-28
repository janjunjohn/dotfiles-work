-- Loaded on the VeryLazy event.
-- LazyVim defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- macOS: switch the input method back to ABC (English) when leaving insert mode,
-- so normal-mode keystrokes aren't eaten by a Japanese IME.
-- Requires the `im-select` CLI (installed via Brewfile). Non-blocking via jobstart.
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    if vim.fn.executable("im-select") == 1 then
      vim.fn.jobstart({ "im-select", "com.apple.keylayout.ABC" })
    end
  end,
})
