local handlers = {}
handlers.goto_implementations = function()
  local params = vim.lsp.util.make_position_params()

  vim.lsp.buf_request(0, "textDocument/implementation", params, function(err, result, ctx, config)
    local ft = vim.api.nvim_get_option_value("filetype", {})

    if ft == "go" and result ~= nil then
      local new_result = vim.tbl_filter(function(v)
        return not string.find(v.uri, "mock_") and not string.find(v.uri, "mocks/")
      end, result)

      if #new_result > 0 then
        result = new_result
      end
    end

    vim.lsp.handlers["textDocument/implementation"](err, result, ctx, config)
  end)
end

return handlers
