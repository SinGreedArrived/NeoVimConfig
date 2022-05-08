require('go').setup({ 
  go='go', -- go command, can be go[default] or go1.18beta1 goimport='gopls', -- goimport command, can be gopls[default] or goimport fillstruct = 'gopls', -- can be nil (use fillstruct, slower) and gopls gofmt = 'gofumpt', --gfmt cmd, max_line_len = 120, -- max line length in goline format tag_transform = false, -- tag_transfer  check gomodifytags for details test_template = '', -- default to testify if not set; g:go_nvim_tests_template  check gotests for details test_template_dir = '', -- default to nil if not set; g:go_nvim_tests_template_dir  check gotests for details comment_placeholder = '' ,  -- comment_placeholder your cool placeholder e.g. ﳑ        icons = {breakpoint = '🧘', currentpos = '🏃'}, verbose = false,  -- output loginf in messages lsp_cfg = false, -- true: use non-default gopls setup specified in go/lsp.lua false: do nothing if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g. lsp_cfg = {settings={gopls={matcher='CaseInsensitive', ['local'] = 'your_local_module_path', gofumpt = true }}} lsp_gofumpt = false, -- true: set default gofmt in gopls format to gofumpt lsp_on_attach = nil, -- nil: use on_attach function defined in go/lsp.lua, when lsp_cfg is true if lsp_on_attach is a function: use this function as on_attach function for gopls lsp_codelens = true, -- set to false to disable codelens, true by default lsp_diag_hdlr = true, -- hook lsp diag handler lsp_document_formatting = true, -- set to true: use gopls to format false if you want to use other formatter tool(e.g. efm, nulls) gopls_cmd = nil, -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile","/var/log/gopls.log" } gopls_remote_auto = true, -- add -remote=auto to gopls dap_debug = true, -- set to false to disable dap dap_debug_keymap = true, -- true: use keymap for debugger defined in go/dap.lua false: do not use keymap in go/dap.lua.  you must define your own. dap_debug_gui = true, -- set to true to enable dap gui, highly recommand dap_debug_vt = true, -- set to true to enable dap virtual text
  build_tags = "tag1,tag2", -- set default build tags
  textobjects = false, -- enable default text jobects through treesittter-text-objects
  test_runner = 'go', -- richgo, go test, richgo, dlv, ginkgo
  run_in_floaterm = false, -- set to true to run in float window.
  --                         float term recommand if you use richgo/ginkgo with terminal color
})

require('lspconfig').gopls.setup({
  filetypes = { "go" }
})

require('guihua.maps').setup({
  maps = {
    close_view = '<C-x>',
  }
})

require("go.format").goimport()

require('greed.golang.ray-x.keymap')
-- require('greed.golang.snippets')

require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  sidebar = {
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with "id" and "size" keys
      {
        id = "scopes",
        size = 0.25, -- Can be float or integer > 1
      },
      { id = "breakpoints", size = 0.25 },
      { id = "stacks", size = 0.25 },
      { id = "watches", size = 00.25 },
    },
    size = 40,
    position = "left", -- Can be "left", "right", "top", "bottom"
  },
  tray = {
    elements = { "repl" },
    size = 10,
    position = "bottom", -- Can be "left", "right", "top", "bottom"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})

require('dap-go').setup()

-- vim.api.nvim_create_augroup('Golang', {
--   clear = true
-- })
-- vim.api.nvim_create_autocmd({'BufWritePre'}, {
--   group = 'Golang',
--   pattern = '*.go',
--   callback = function()
--     require('go.format').goimport()
--   end,
-- })

vim.cmd [[
  augroup Golang
    autocmd!
    autocmd BufWritePre *.go :silent! lua require('go.format').goimport()
  augroup end
]]
