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
  function(use)
    use 'wbthomason/packer.nvim'
    -- nvim-cmp
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
    -- LuaSnip
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
    --
    -- nvim-tree
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
    -- lsp
    use {
      "neovim/nvim-lspconfig",
      requires = {
        { "williamboman/nvim-lsp-installer" },
      },
      config = function()
        require( config_dir .. 'lsp')
      end,
    }
   use {
     "numToStr/Comment.nvim",
     config = function()
       require'Comment'.setup()
     end,
   }
   use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
      { 'nvim-treesitter/playground' },
      { 'ray-x/cmp-treesitter' },
    },
    config = function()
      require( config_dir .. 'nvim-treesitter' )
    end
   }
    use {
      'ray-x/go.nvim',
      requires = {
        { 'mfussenegger/nvim-dap' },
        { 'rcarriga/nvim-dap-ui' },
        { 'theHamsta/nvim-dap-virtual-text' },
        { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' },
      },
      config = function()
          require( config_dir .. 'go-nvim')
      end
    }
    use {
      'sumneko/lua-language-server',
    }
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
    use {
      "NTBBloodbath/rest.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require( config_dir .. "rest" )
      end
    }
    use {
      'sindrets/diffview.nvim',
    }
    -- use {
    --   'lewis6991/gitsigns.nvim',
    --   config = function()
    --     require('gitsigns').setup()
    --   end
    -- }
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
    -- Themes
    use {
	  'morhetz/gruvbox',
	  config = function()
		vim.cmd [[ colorscheme gruvbox ]]
	  end
    }
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

