-- install packer automatically on new system
-- https://github.com/wbthomason/packer.nvim#bootstrapping
local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
end

return require("packer").startup {
  -- Plugins
  function(use)
    -- wbthomason/packer.nvim
    use {
      'wbthomason/packer.nvim',
    }
    -- hrsh7th/nvim-cmp
    use {
      "hrsh7th/nvim-cmp",
      requires = {
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-nvim-lua' },
        { 'hrsh7th/cmp-cmdline' },
        { 'hrsh7th/cmp-buffer' },
        { 'tamago324/cmp-zsh' },
        { 'hrsh7th/cmp-path' },
        { 'onsails/lspkind-nvim' },
      },
      config = function()
        require( config_dir .. 'completion')
      end,
    }
    -- ray-x/go.nvim
    use {
      'ray-x/go.nvim',
      requires = {
        { 'ray-x/guihua.lua' }
      },
      config = function()
        require('go').setup()
      end
    }
    -- L3MON4D3/LuaSnip
    use {
      'L3MON4D3/LuaSnip',
      requires = {
        { 'saadparwaiz1/cmp_luasnip' },
        { 'rafamadriz/friendly-snippets' },
      },
      config = function()
        require( config_dir .. 'luasnip')
      end
    }
    -- kyazdani42/nvim-tree.lua
    use {
      'kyazdani42/nvim-tree.lua',
      requires = {
        'kyazdani42/nvim-web-devicons', -- optional, for file icon
      },
      config = function()
        require( config_dir .. 'nvim-tree' )
      end,
      tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }
    -- neovim/nvim-lspconfig
    use {
      "neovim/nvim-lspconfig",
      requires = {
        { "williamboman/nvim-lsp-installer" },
      },
      config = function()
        require( config_dir .. 'lsp_cnf')
      end,
    }
    -- numToStr/Comment.nvim
    use {
      "numToStr/Comment.nvim",
      config = function()
        require'Comment'.setup()
      end,
    }
    -- nvim-treesitter/nvim-treesitter
    use {
      'nvim-treesitter/nvim-treesitter',
      requires = {
        { 'nvim-treesitter/nvim-treesitter-textobjects' },
        { 'nvim-treesitter/playground' },
      },
      config = function()
        require( config_dir .. 'nvim-treesitter' )
      end
    }
    -- mfussenegger/nvim-dap
    use {
      'mfussenegger/nvim-dap',
      requires = {
        { 'leoluz/nvim-dap-go' },
        { 'rcarriga/nvim-dap-ui' },
        { 'theHamsta/nvim-dap-virtual-text' },
        { 'nvim-telescope/telescope-dap.nvim' },
      },
      config = function()
        require( config_dir .. 'dap')
      end
    }
    -- sumneko/lua-language-server
    use {
      'sumneko/lua-language-server',
    }
    -- nvim-telescope/telescope.nvim
    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        { 'kdheepak/lazygit.nvim' },
      },
      config = function ()
        require( config_dir .. 'nvim-telescope' )
      end
    }
    -- akinsho/bufferline.nvim
    use {
      'akinsho/bufferline.nvim',
      tag = "v2.*",
      requires = {
        { 'kyazdani42/nvim-web-devicons' },
      },
      config = function ()
        require( config_dir .. 'bufferline' )
      end
    }
    -- NTBBloodbath/rest.nvim
    use {
      "NTBBloodbath/rest.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require( config_dir .. "rest" )
      end
    }
    -- sindrets/diffview.nvim
    use {
      'sindrets/diffview.nvim',
    }
    -- lewis6991/gitsigns.nvim
    use {
      'lewis6991/gitsigns.nvim',
      config = function()
        require( config_dir .. "gitsigns" )
      end
    }
    -- edolphin-ydf/goimpl.nvim
    use {
      'edolphin-ydf/goimpl.nvim',
      requires = {
        {'nvim-lua/plenary.nvim'},
        {'nvim-lua/popup.nvim'},
        {'nvim-telescope/telescope.nvim'},
        {'nvim-treesitter/nvim-treesitter'},
      },
      config = function()
        require'telescope'.load_extension'goimpl'
      end,
    }
    -- anuvyklack/pretty-fold.nvim
    use {
      'anuvyklack/pretty-fold.nvim',
      -- requires = 'anuvyklack/nvim-keymap-amend', -- only for preview
      config = function()
        require('pretty-fold').setup{
          keep_indentation = false,
          fill_char = '━',
          sections = {
            left = {
              '━ ', function() return string.rep('*', vim.v.foldlevel) end, ' ━┫', 'content', '┣'
            },
            right = {
              '┫ ', 'number_of_folded_lines', ': ', 'percentage', ' ┣━━',
            }
          }
        }
        -- require('pretty-fold.preview').setup()
      end
    }
    -- -- kevinhwang91/nvim-ufo
    -- use {
    --   'kevinhwang91/nvim-ufo',
    --   requires = 'kevinhwang91/promise-async',
    --   config = function ()
    --     vim.wo.foldcolumn = '1'
    --     vim.wo.foldlevel = 99 -- feel free to decrease the value
    --     vim.wo.foldenable = true
    --     local capabilities = vim.lsp.protocol.make_client_capabilities()
    --     capabilities.textDocument.foldingRange = {
    --         dynamicRegistration = false,
    --         lineFoldingOnly = true
    --     }
    --     require('ufo').setup()
    --   end,
    -- }
    -- feline-nvim/feline.nvim
    use {
      'feline-nvim/feline.nvim',
      config = function ()
        require('feline').setup()
      end,
    }
    -- morhetz/gruvbox
    use {
      'morhetz/gruvbox',
      config = function()
        vim.cmd [[ colorscheme gruvbox ]]
      end
    }
    -- PACKER_BOOTSTRAP
    if PACKER_BOOTSTRAP then
      require("packer").sync()
    end
  end,
  config = {
    display = {
      open_fn = require("packer.util").float,
    },
  },
}
