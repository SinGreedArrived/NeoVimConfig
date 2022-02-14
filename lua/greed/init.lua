local cmp = require'cmp'
cmp.setup({
  mapping = {
      ["<CR>"] = cmp.mapping.confirm(),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  }),
  snippet = {
    expand = function(args)
        local luasnip = require("luasnip")
        if not luasnip then
            return
        end
        luasnip.lsp_expand(args.body)
    end,
  }
})
-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})
-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
