local map = vim.api.nvim_set_keymap
local cmp = require'cmp'
local default_opts = {noremap = true, silent = true}

map('n', '<S-h>', '<cmd>BufferLineMovePrev<CR>', default_opts)
map('n', '<S-l>', '<cmd>BufferLineMoveNext<CR>', default_opts)
