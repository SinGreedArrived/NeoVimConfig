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

--	  sonokai = 'sainnhe/sonokai',
--	  sonokai = vim [[ colorthem sonokai ]],

-- sync plugins on write/save
vim.cmd [[
  augroup packer_sync_plugins
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

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
        { 'L3MON4D3/LuaSnip' },
        { 'saadparwaiz1/cmp_luasnip' },
--        { 'dcampos/nvim-snippy' },
--        { 'dcampos/cmp-snippy' },
      },
    config = function()
      require( config_dir .. 'completion')
    end,
    }
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
   --  use 'nvim-lua/plenary.nvim'
   --  use 'nvim-lua/popup.nvim'
   --  use 'tveskag/nvim-blame-line'
   --  use {
   --      'nvim-treesitter/nvim-treesitter',
   --      run = ':TSUpdate',
   --      config = function()
   --        require('greed.treesitter')
   --      end,
   --  }
    -- use "BurntSushi/ripgrep"
   --  use "onsails/lspkind-nvim"
   --  use {
   --    "numToStr/Comment.nvim",
   --    config = function()
   --      require'Comment'.setup()
   --    end,
   --  }
   --  use {
   --    'nvim-telescope/telescope.nvim',
   --    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
   --    config = function()
   --      require('greed.telescope')
   --    end,
   --  }
   --  use { "leoluz/nvim-dap-go" }
   --  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
   --  use {'ray-x/guihua.lua', run = 'cd lua/fzy && make'}
   --  use {
   --    'ray-x/go.nvim',
   --    requires = {
   --      { 'mfussenegger/nvim-dap' },
   --      { 'rcarriga/nvim-dap-ui' },
   --      { 'theHamsta/nvim-dap-virtual-text' },
   --    },
   --    config = function()
   --        require('greed.golang.ray-x')
   --    end
   --  }
	  -- use {
   --    'L3MON4D3/LuaSnip',
   --    config = function()
   --      require('greed.golang.snippets')
   --    end
   --  }
  	-- use 'saadparwaiz1/cmp_luasnip'
   --  use {
   --    "lewis6991/gitsigns.nvim",
   --    requires = { "nvim-lua/plenary.nvim" },
   --  }
   --  use {
   --    'nvim-lualine/lualine.nvim',
   --    config = function()
   --      require'greed.lualine'
   --    end,
   --    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
   --  }
   --  use {
   --    'kdheepak/tabline.nvim',
   --    config = function()
   --      require'greed.tabline'
   --    end,
   --    requires = { { 'hoob3rt/lualine.nvim', opt=true }, {'kyazdani42/nvim-web-devicons', opt = true} }
   --  }
   --  use {
   --    'kyazdani42/nvim-tree.lua',
   --    requires = {
   --      'kyazdani42/nvim-web-devicons', -- optional, for file icon
   --    },
   --    config = function()
   --      require'greed.nvim-tree'
   --    end
   --  }
   --  use {
   --    'preservim/tagbar'
   --  }
   --  use {
   --    "NTBBloodbath/rest.nvim",
   --    requires = { "nvim-lua/plenary.nvim" },
   --    config = function()
   --      require'greed.rest'
   --    end
   --  }
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

