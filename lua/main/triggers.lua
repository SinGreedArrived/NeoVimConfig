-- packer group
local plugins_sync = vim.api.nvim_create_augroup("packer_sync_plugins",
                                                 {clear = true})
vim.api.nvim_create_autocmd("BufWritePost", {
    command = "source % | PackerSync",
    group = plugins_sync,
    pattern = "plugins.lua"
})
-- remembers group
local remembers = vim.api.nvim_create_augroup("remembers", {clear = true})
vim.api.nvim_create_autocmd("BufWinLeave", {
    command = "silent! mkview",
    group = remembers,
    pattern = "*.*"
})
vim.api.nvim_create_autocmd("BufWinEnter", {
    command = "silent! loadview",
    group = remembers,
    pattern = "*.*"
})
-- golang
local golang = vim.api.nvim_create_augroup("golang", {clear = true})
vim.api.nvim_create_autocmd("BufWritePre", {
    group = golang,
    pattern = "*.go",
    command = "silent! lua require('go.format').goimport()"
})

-- Lua
local lua = vim.api.nvim_create_augroup("lua", {clear = true})
vim.api.nvim_create_autocmd("BufWritePre", {
    group = lua,
    pattern = "*.lua",
    command = "silent! call LuaFormat()"
})
