-- install packer automatically on new system
-- https://github.com/wbthomason/packer.nvim#bootstrapping
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

return require("packer").startup({
	-- Plugins
	function(use)
		-- wbthomason/packer.nvim
		use({ "wbthomason/packer.nvim" })
		-- hrsh7th/nvim-cmp
		use({
			"hrsh7th/nvim-cmp",
			requires = {
				{ "neovim/nvim-lspconfig" },
				{ "hrsh7th/cmp-nvim-lsp" },
				{ "hrsh7th/cmp-nvim-lua" },
				{ "hrsh7th/cmp-cmdline" },
				{ "hrsh7th/cmp-buffer" },
				{ "tamago324/cmp-zsh" },
				{ "hrsh7th/cmp-path" },
				{ "onsails/lspkind-nvim" },
			},
			config = function()
				require(config_dir .. "completion")
			end,
		})
		-- ray-x/go.nvim
		use({
			"ray-x/go.nvim",
  		requires = {  -- optional packages
  		  "ray-x/guihua.lua",
  		  "neovim/nvim-lspconfig",
  		  "nvim-treesitter/nvim-treesitter",
  		},
  		config = function()
  		  require("go").setup({
					goimports ='gopls', -- goimports command, can be gopls[default] or either goimports or golines if need to split long lines
					gofmt = 'golines', -- gofmt through gopls: alternative is gofumpt, goimports, golines, gofmt, etc
					max_line_len = 80,
				})
  		end,
  		event = {"CmdlineEnter"},
  		ft = {"go", 'gomod'},
  		build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
		})
		-- L3MON4D3/LuaSnip
		use({
			"L3MON4D3/LuaSnip",
			requires = {
				{ "saadparwaiz1/cmp_luasnip" },
				{ "rafamadriz/friendly-snippets" },
			},
			config = function()
				require(config_dir .. "luasnip")
			end,
		})
		-- kyazdani42/nvim-tree.lua
		use({
			"kyazdani42/nvim-tree.lua",
			requires = {
				"kyazdani42/nvim-web-devicons", -- optional, for file icon
			},
			config = function()
				require(config_dir .. "nvim-tree")
			end,
			tag = "nightly", -- optional, updated every week. (see issue #1193)
		})
		-- neovim/nvim-lspconfig
		use({
			"neovim/nvim-lspconfig",
			requires = { { "williamboman/nvim-lsp-installer" } },
			config = function()
				require(config_dir .. "lsp_cnf")
			end,
		})
		-- numToStr/Comment.nvim
		use({
			"numToStr/Comment.nvim",
			config = function()
				require("Comment").setup()
			end,
		})
		-- nvim-treesitter/nvim-treesitter
		use({
			"nvim-treesitter/nvim-treesitter",
			requires = {
				{ "nvim-treesitter/nvim-treesitter-textobjects" },
				{ "nvim-treesitter/playground" },
			},
			config = function()
				require(config_dir .. "nvim-treesitter")
			end,
		})
		-- mfussenegger/nvim-dap
		use({
			"mfussenegger/nvim-dap",
			requires = {
				{ "leoluz/nvim-dap-go" },
				{ "rcarriga/nvim-dap-ui" },
				{ "theHamsta/nvim-dap-virtual-text" },
				{ "nvim-telescope/telescope-dap.nvim" },
				{ "nvim-neotest/nvim-nio" },
			},
			config = function()
				require(config_dir .. "dap")
			end,
		})
		-- sumneko/lua-language-server
		use({ "sumneko/lua-language-server" })
		-- nvim-telescope/telescope.nvim
		use({
			"nvim-telescope/telescope.nvim",
			requires = {
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
				{ "kdheepak/lazygit.nvim" },
			},
			config = function()
				require(config_dir .. "nvim-telescope")
			end,
		})
		-- akinsho/bufferline.nvim
		use ({
			'akinsho/bufferline.nvim',
			tag = "*",
			requires = 'nvim-tree/nvim-web-devicons',
			config = function()
				require(config_dir .. "bufferline")
			end,
		})
		-- junegunn/fzf
		use({
			"junegunn/fzf",
			run = function()
				vim.fn["fzf#install"]()
			end,
		})
		-- lewis6991/gitsigns.nvim
		use({
			"lewis6991/gitsigns.nvim",
			config = function()
				require(config_dir .. "gitsigns")
			end,
		})
		-- edolphin-ydf/goimpl.nvim
		use({
			"edolphin-ydf/goimpl.nvim",
			requires = {
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-lua/popup.nvim" },
				{ "nvim-telescope/telescope.nvim" },
				{ "nvim-treesitter/nvim-treesitter" },
			},
			config = function()
				require("telescope").load_extension("goimpl")
			end,
		})
		-- anuvyklack/pretty-fold.nvim
		use({
			"anuvyklack/pretty-fold.nvim",
			-- requires = 'anuvyklack/nvim-keymap-amend', -- only for preview
			config = function()
				require("pretty-fold").setup({
					keep_indentation = false,
					fill_char = "━",
					sections = {
						left = {
							"━ ",
							function()
								return string.rep("*", vim.v.foldlevel)
							end,
							" ━┫",
							"content",
							"┣",
						},
						right = {
							"┫ ",
							"number_of_folded_lines",
							": ",
							"percentage",
							" ┣━━",
						},
					},
				})
				-- require('pretty-fold.preview').setup()
			end,
		})
		-- kndndrj/nvim-dbee
		-- use({
		-- 	"kndndrj/nvim-dbee",
		-- 	requires = {
		-- 		"MunifTanjim/nui.nvim",
		-- 	},
		-- 	run = function()
		-- 	-- Install tries to automatically detect the install method.
		-- 	-- if it fails, try calling it with one of these parameters:
		-- 	--    "curl", "wget", "bitsadmin", "go"
		-- 		require("dbee").install()
		-- 	end,
		-- 	config = function()
		-- 		require("dbee").setup(--[[optional config]])
		-- 	end
		-- })
		-- andrejlevkovitch/vim-lua-format
		-- use {'andrejlevkovitch/vim-lua-format'}
		--
		use({
			"mhartington/formatter.nvim",
			config = function()
				require(config_dir .. "lua_formatter")
			end,
		})
		-- feline-nvim/feline.nvim
		use({
			"feline-nvim/feline.nvim",
			config = function()
				require("feline").setup()
			end,
		})
		-- morhetz/gruvbox
		use({
			"morhetz/gruvbox",
			config = function()
				vim.cmd([[ colorscheme gruvbox ]])
			end,
		})
		-- colorizer
		use({
			"norcalli/nvim-colorizer.lua",
			config = function()
				require("colorizer").setup()
			end,
		})
		-- color picker
		use({
			"ziontee113/color-picker.nvim",
			config = function()
				require("color-picker")
			end,
		})
		if PACKER_BOOTSTRAP then
			require("packer").sync()
		end
	end,
	config = { display = { open_fn = require("packer.util").float } },
})
