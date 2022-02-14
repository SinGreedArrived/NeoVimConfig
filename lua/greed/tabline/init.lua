require'tabline'.setup {
  -- Defaults configuration options
  enable = false,
  -- options = {
  -- -- If lualine is installed tabline will use separators configured in lualine by default.
  -- -- These options can be used to override those settings.
  --   section_separators = {'', ''},
  --   component_separators = {'', ''},
  --   max_bufferline_percent = 66, -- set to nil by default, and it uses vim.o.columns * 2/3
  --   show_tabs_always = false, -- this shows tabs only when there are more than one tab or if the first tab is named
  --   show_devicons = true, -- this shows devicons in buffer section
  --   show_bufnr = false, -- this appends [bufnr] to buffer section,
  --   show_filename_only = false, -- shows base filename only instead of relative path in filename
  -- }
}

-- require'lualine'.setup{
--   tabline = {
--     lualine_a = {},
--     lualine_b = {},
--     lualine_c = { require'tabline'.tabline_buffers },
--     lualine_x = { require'tabline'.tabline_tabs },
--     lualine_y = {},
--     lualine_z = {},
--   },
-- }
-- vim.cmd[[
--   set guioptions-=e " Use showtabline in gui vim
--   set sessionoptions+=tabpages,globals " store tabpages and globals in session
-- ]]
