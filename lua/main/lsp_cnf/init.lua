local util = require "lspconfig/util"
local nvim_config = require('lspconfig')

require("nvim-lsp-installer").setup({
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
})

nvim_config.gopls.setup {
  -- on_attach = on_attach,
  cmd = {"gopls", "serve"},
  filetypes = {"go", "gomod"},
  root_dir = util.root_pattern("go.mod", ".git"),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
  flags = {
    -- This will be the default in neovim 0.7+
    debounce_text_changes = 150,
  }
}
nvim_config.sumneko_lua.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
--        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
nvim_config.pyright.setup{}
nvim_config.golangci_lint_ls.setup{}
nvim_config.rust_analyzer.setup{}
nvim_config.sqlls.setup{}
nvim_config.dockerls.setup{}
nvim_config.phpactor.setup{}
require(config_dir .. "lsp_cnf.handlers")
