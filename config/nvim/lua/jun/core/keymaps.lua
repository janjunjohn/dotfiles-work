local keymap = vim.keymap

keymap.set('n', 'x', '"_x')

-- open explore
keymap.set('n', 'se', ':Explore')

-- Increment/decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- delete a word backwards
keymap.set('n', 'dw', 'vb"_d')

-- Select all
keymap.set('n', '<C-a>', 'gg<S-v>G')

-- save file and run python
keymap.set('n', 'ss', ':w | !python %')
