require('go').setup({
        auto_format = true,
        auto_lint = true,
        linter = 'golangci-lint',
        linter_flags = { golangci_lint = { '-c', '~/.config/nvim/lua/greed/golang/golangci.yml' } },
        lint_prompt_style = 'vt',
        formatter = 'goimports',
        test_flags = {'-v'},
        test_timeout = '30s',
        test_env = {},
        test_popup = true,
        test_popup_width = 120,
        test_popup_height = 15,
        test_open_cmd = 'edit',
        tags_name = 'json',
        tags_options = {'json=omitempty'},
        tags_transform = 'snakecase',
        tags_flags = {'-skip-unexported'},
        quick_type_flags = {'--just-types'},
})

-- setup lsp client
-- require('lspconfig').gopls.setup({
--   filetypes = { "go" }
-- })
-- require'lspconfig'.golangci_lint_ls.setup{
--   filetypes = { "go" }
-- }
require('greed.golang.nvim-go.keymap')
require('greed.golang.snippets')
