require "nvim-treesitter.configs".setup {
  ensure_installed = { "go", "lua", "python", "dockerfile", "rust" },
  sync_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
  },
}
