local nvim_lsp = require("lspconfig")
local lsp_handlers = require("lsp_handlers")

local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

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
  vim.keymap.set("n", "gi", function()
      vim.cmd("tab split")
      lsp_handlers.goto_implementations()
  end, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "cn", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

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
        },
    },
})

nvim_lsp.rust_analyzer.setup({
    cmd = {"rustup", "run", "stable", "rust-analyzer"},
    on_attach = on_attach,
})

require("fidget").setup()

local cmp_menu = {
    nvim_lua = "[lua]",
    nvim_lsp = "[LSP]",
    buffer = "[buf]",
}

local get_cmp_source = function(source_name)
    local r = cmp_menu[source_name]
    if r ~= nil then
        return r
    end

    return "[" .. source_name .. "]"
end

local cmp = require("cmp")
cmp.setup {
    mapping = cmp.mapping.preset.insert({
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = {
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "buffer", keyword_length = 5 },
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = get_cmp_source(entry.source.name)
            return vim_item
        end
    },
    experimental = {
        native_menu = false,
        ghost_text = true,
    },
}
