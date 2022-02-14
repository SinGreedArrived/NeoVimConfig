local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true, silent = true}

map('', '<F3>', '<cmd>NvimTreeToggle<CR>', default_opts)
map('', '<leader>r', '<cmd>NvimTreeRefresh<CR>', default_opts)
