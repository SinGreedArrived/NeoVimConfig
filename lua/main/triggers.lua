-- sync plugins on write/save
local plugins_sync = vim.api.nvim_create_augroup("packer_sync_plugins", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", { command = "source % | PackerSync", group = plugins_sync, pattern = "plugins.lua" })
--
local golang = vim.api.nvim_create_augroup("golang", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", { command = "silent! lua require('go.format').goimport()", group = golang, pattern = "*.go" })
--vim.api.nvim_create_autocmd("BufWritePre", { command = "lua vim.lsp.buf.code_action()", pattern = "*.go", group = golang,})
