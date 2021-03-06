local map = vim.api.nvim_set_keymap
local cmp = require'cmp'
local default_opts = {noremap = true, silent = true}

map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', default_opts)
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', default_opts)
-- map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', default_opts)
map('n', 'K', '<cmd>GoDoc<CR>', default_opts)
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', default_opts)
map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', default_opts)
map('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', default_opts)
map('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', default_opts)
map('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', default_opts)
map('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', default_opts)
map('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', default_opts)
map('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', default_opts)
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', default_opts)
map('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', default_opts)
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', default_opts)
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', default_opts)
map('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', default_opts)
map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', default_opts)
map('n', 'gt', '<cmd>GoAddTags<CR>', default_opts)
map('n', '<F7>', '<cmd>GoBreakToggle<CR>', default_opts)
map('n', '<F8>', '<cmd>GoDebug test<CR>', default_opts)
map('n', '<F9>', '<cmd>GoDebug stop<CR><cmd>so ~/.config/nvim/lua/greed/golang/ray-x/keymap.lua<CR>', default_opts)
