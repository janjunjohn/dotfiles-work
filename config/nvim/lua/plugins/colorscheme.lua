-- Keep the night-owl theme (matches the VSCode setup) instead of LazyVim's default.
return {
  { "oxfist/night-owl.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "night-owl",
    },
  },
}
