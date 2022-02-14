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

-- sync plugins on write/save
vim.cmd [[
  augroup packer_sync_plugins
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

return require("packer").startup {
  function(use)
    use "wbthomason/packer.nvim"
    use 'nvim-lua/plenary.nvim'
    use 'nvim-lua/popup.nvim'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
          require('greed.treesitter')
        end,
    }
    use "BurntSushi/ripgrep"
    use "neovim/nvim-lspconfig"
    use "onsails/lspkind-nvim"
    use {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end,
    }
    -- nvim-cmp
    use {
      "hrsh7th/nvim-cmp",
      requires = {
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-cmdline" },
        { "tamago324/cmp-zsh" },
      },
      config = function()
        require "greed.completion"
      end,
    } 
    use {
      'nvim-telescope/telescope.nvim',
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
      config = function()
        require('greed.telescope')
      end,
    }
    use {
      'ray-x/go.nvim',
      requires = {
        { 'mfussenegger/nvim-dap' },
        { 'rcarriga/nvim-dap-ui' },
        { 'theHamsta/nvim-dap-virtual-text' },
      },
      config = function()
        require"greed.golang.ray-x"
      end
    }
    -- use {
    --   'crispgm/nvim-go',
    --   require = {
    --     {'nvim-lua/plenary.nvim'},
    --     {'nvim-lua/popup.nvim'},
    --   },
    --   config = function()
    --     require "greed.golang.nvim-go"
    --   end,
    -- }
	  use 'L3MON4D3/LuaSnip'
  	use 'saadparwaiz1/cmp_luasnip'

    use {
      "lewis6991/gitsigns.nvim",
      requires = { "nvim-lua/plenary.nvim" },
    }
    use 'sainnhe/sonokai'
    use {
      'nvim-lualine/lualine.nvim',
      config = function() 
        require'greed.lualine'
      end,
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use {
      'kdheepak/tabline.nvim',
      config = function()
        require'greed.tabline'
      end,
      requires = { { 'hoob3rt/lualine.nvim', opt=true }, {'kyazdani42/nvim-web-devicons', opt = true} }
    }
    -- use {
    --   'pwntester/octo.nvim',
    --   requires = {
    --     'nvim-lua/plenary.nvim',
    --     'nvim-telescope/telescope.nvim',
    --     'kyazdani42/nvim-web-devicons',
    --   },
    --   config = function ()
    --     require'greed.octo'
    --   end
    -- }
    use {
      'kyazdani42/nvim-tree.lua',
      requires = {
        'kyazdani42/nvim-web-devicons', -- optional, for file icon
      },
      config = function()
        require'greed.nvim-tree'
      end
    }
    use {
      'akinsho/bufferline.nvim', 
      requires = 'kyazdani42/nvim-web-devicons',
      config = function()
        require'greed.bufferline'
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
