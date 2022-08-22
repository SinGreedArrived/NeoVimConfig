local M = {}

M.implementation  = function ()
  local params = vim.lsp.util.make_position_params()

  vim.lsp.buf_request(0, "textDocument/implementation", params, function (err, result, ctx, config)
    local ft = vim.api.nvim_buf_get_option(ctx.bufnr, "filetype")

    if ft == "go" then
      local newResult = vim.tbl_filter(function (v)
        return not string.find(v.uri, ".pb.go")
      end, result)

      if #newResult > 0 then
        result = newResult
      end
    end

    vim.lsp.handlers["textDocument/implementation"](err, result, ctx, config)
  end)
end

return M
