local nvim_lsp = require("lspconfig")

local function show_items(options)
  position_encoding = vim.lsp.get_clients({ bufnr = 0 })[1].offset_encoding

  if #options.items == 1 then
    local tagname = vim.fn.expand('<cword>')
    local from = vim.fn.getpos('.')
    local current_win = vim.api.nvim_get_current_win()

    local item = options.items[1]
    local b = item.bufnr or vim.fn.bufadd(item.filename)

    vim.cmd("normal! m'")
    local tagstack = { { tagname = tagname, from = from } }
    vim.fn.settagstack(vim.fn.win_getid(current_win), { items = tagstack }, 't')

    vim.bo[b].buflisted = true

    -- open in current window if it matches
    local wins = vim.fn.win_findbuf(b)
    local w = wins[1]
    for _, v in ipairs(wins) do
      if v == current_win then
        w = v
        break
      end
    end

    vim.api.nvim_win_set_buf(w, b)
    print(item.lnum, item.col)
    vim.api.nvim_win_set_cursor(w, { item.lnum, item.col - 1 })
    vim._with({ win = w }, function()
      vim.cmd('normal! zv')
    end)

    return
  end

  vim.fn.setqflist({}, " ", {
    title = options.title,
    items = options.items,
  })
  vim.cmd('botright copen')
end

local goto_implementations = function()
  vim.lsp.buf.implementation({ on_list = function(options)
    local ft = vim.api.nvim_get_option_value("filetype", {})

    if ft == "go" and options.items ~= nil then
      local items = vim.tbl_filter(function(v)
        return not string.find(v.filename, "mock_") and not string.find(v.filename, "mocks/")
      end, options.items)

      if #items > 0 then
        options.items = items
      end
    end

    show_items(options)
  end})
end

local function show_references_no_tests()
  vim.lsp.buf.references({ includeDeclaration = false }, { on_list = function(options)
    local ft = vim.api.nvim_get_option_value("filetype", {})

    if ft == "go" and options.items ~= nil then
      local items = vim.tbl_filter(function(v)
        return not string.find(v.filename, "_test.go")
      end, options.items)

      if #items > 0 then
       options.items = items
      end
    end

    show_items(options)
  end})
end

local on_attach = function(_, bufnr)
  local opts = { noremap=true, silent=true, buffer = bufnr }

  vim.keymap.set("n", "gdd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gdt", function()
      vim.cmd("tab split")
      vim.lsp.buf.definition()
  end, opts)
  vim.keymap.set("n", "gds", function()
      vim.cmd("vsplit")
      vim.lsp.buf.definition()
  end, opts)
  vim.keymap.set("n", "gri", function()
      vim.cmd("tab split")
      goto_implementations()
  end, opts)
  vim.keymap.set("n", "grr", show_references_no_tests, opts)
  vim.keymap.set("n", "cn", function() vim.diagnostic.jump({ count = 1 }) end, opts)

  require("lsp_signature").on_attach({
      bind = true, -- This is mandatory, otherwise border config won"t get registered.
      handler_opts = {
        border = "rounded"
      }
  })
end

local util = require "lspconfig.util"

nvim_lsp.gopls.setup({
    on_attach = on_attach,
    root_dir = util.root_pattern("go.mod", "doc.go"),
})

nvim_lsp.clangd.setup({
    on_attach = on_attach,
})

nvim_lsp.lua_ls.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
                disable = { "lowercase-global" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
            format = {
                enable = true,
            },
        },
    },
})

nvim_lsp.rust_analyzer.setup({
    cmd = {"rustup", "run", "stable", "rust-analyzer"},
    on_attach = on_attach,
})

