local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true, silent = true}

vim.cmd [[
  nnoremap <Plug>RestNvim :lua require('rest-nvim').run()<CR>
]]

map('n', '<leader>e', '<Plug>RestNvim', default_opts)
