local cmd = vim.cmd             -- execute Vim commands
local exec = vim.api.nvim_exec  -- execute Vimscript
local g = vim.g                 -- global variables
local opt = vim.opt             -- global/buffer/windows-scoped options

g.ale_sign_error = '❌'
g.ale_sign_warning = '⚠️'
g.ale_fix_on_save = 1

opt.colorcolumn = '80'
opt.cursorline = true

vim.o.ruler = false
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.ignorecase = true
vim.o.hlsearch = true
vim.o.background = 'dark'
vim.o.termguicolors = true
vim.o.hidden = true
vim.o.updatetime = 300
vim.o.scrolloff = 5
vim.o.sidescrolloff = 5
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.showmode = false

vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = 'number'
vim.wo.wrap = false

vim.o.tabstop = 2
vim.bo.tabstop = 2
vim.o.softtabstop = 2
vim.bo.softtabstop = 2
vim.o.shiftwidth = 2
vim.bo.shiftwidth = 2
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.expandtab = true
vim.bo.expandtab = true

vim.wo.list = true
vim.o.listchars = 'tab:┆·,trail:·,precedes:,extends:'

vim.g.markdown_fenced_languages = {'zsh', 'nvim', 'go' }

vim.g.termbufm_direction_cmd = 'new'

vim.o.termguicolors = true
--cmd "colorscheme sonokai"
g.mouse = 'a'
