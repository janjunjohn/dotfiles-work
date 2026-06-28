-- VSCode-style side-by-side / inline diff, for reviewing Claude's changes in the
-- terminal. Lazy-loads on :CodeDiff. No build step (downloads a prebuilt binary).
-- craftzdog contributed an explorer `auto_open_on_cursor` option upstream; once
-- you've confirmed the plugin loads, you can enable it via an `opts = { explorer
-- = { auto_open_on_cursor = true } }` table here (check :h codediff for the schema).
return {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",
}
