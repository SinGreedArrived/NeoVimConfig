-- packer group
local plugins_sync = vim.api.nvim_create_augroup("packer_sync_plugins", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", { command = "source % | PackerSync", group = plugins_sync, pattern = "plugins.lua" })
-- golang group
local golang = vim.api.nvim_create_augroup("golang", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", { command = "silent! lua require('go.format').goimport()", group = golang, pattern = "*.go" })
-- remembers group
local remembers = vim.api.nvim_create_augroup("remembers", { clear = true })
vim.api.nvim_create_autocmd("BufWinLeave", { command = "mkview", group = remembers, pattern = "*" })
vim.api.nvim_create_autocmd("BufWinEnter", { command = "silent! loadview", group = remembers, pattern = "*" })
