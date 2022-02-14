local map = vim.api.nvim_set_keymap
local cmp = require'cmp'
local default_opts = {noremap = true, silent = true}
-- local ignore_patterns = "{ file_ignore_patterns = { 'target/' } }"

map('', ';f', '<cmd>lua require("telescope.builtin").find_files({ hidden = true })<CR>',default_opts) 
map('', ';e', '<cmd>lua require("telescope.builtin").live_grep()<CR>', default_opts)
map('', ';b', '<cmd>lua require("telescope.builtin").buffers()<CR>', default_opts)
map('', '<leader>m', '<cmd>Telescope metals commands<CR>', default_opts)
