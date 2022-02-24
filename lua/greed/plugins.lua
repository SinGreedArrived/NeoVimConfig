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
        local lspkind = require'lspkind'
        lspkind.init {
          mode = "symbol_text",
          symbol_map = {
            Text = "",
            Method = "ƒ",
            Function = "ﬦ",
            Constructor = "",
            Variable = "",
            Class = "",
            Interface = "ﰮ",
            Module = "",
            Property = "",
            Unit = "",
            Value = "",
            Enum = "了",
            Keyword = "",
            Snippet = "﬌",
            Color = "",
            File = "",
            Folder = "",
            EnumMember = "",
            Constant = "",
            Struct = "",
          },
        }
        
        local cmp = require'cmp'
        cmp.setup {
          snippet = {
            expand = function(args)
                local luasnip = require("luasnip")
                if not luasnip then
                    return
                end
                luasnip.lsp_expand(args.body)
            end,
          },
          mapping = {
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping {
              i = cmp.mapping.confirm { select = true },
            },
            ["<Right>"] = cmp.mapping {
              i = cmp.mapping.confirm { select = true },
            },
            ["<C-J>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
            ["<C-K>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert }, { "i" }),
            ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert }, { "i" }),
          },
          experimental = {
            ghost_text = true,
          },
          documentation = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
          },
          sources = {
            { name = "nvim_lsp" },
            { name = "path" },
            { name = "luasnip" },
            {
              name = "buffer",
              option = {
                get_bufnrs = function()
                  return vim.api.nvim_list_bufs()
                end,
              },
            },
          },
          formatting = {
            format = function(entry, vim_item)
              vim_item.kind = string.format("%s %s", lspkind.presets.default[vim_item.kind], vim_item.kind)
              vim_item.menu = ({
                nvim_lsp = "ﲳ",
                nvim_lua = "",
                path = "ﱮ",
                buffer = "﬘",
                zsh = "",
              })[entry.source.name]
        
              return vim_item
            end,
          },
        }
        
        -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline('/', {
          sources = {
            { name = 'buffer' }
          }
        })
        -- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          })
        })
        --require('greed.completion')
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
