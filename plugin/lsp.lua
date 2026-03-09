local on_attach = require("lsp").on_attach

vim.lsp.config('gopls', {
    on_attach = on_attach,
    settings = {
        gopls = {
            analyses = {
                any = false,
            },
        },
    },
})

vim.lsp.enable('gopls')

vim.lsp.config('clangd', {
    on_attach = on_attach,
})
vim.lsp.enable('clangd')

vim.lsp.config('lua_ls', {
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
vim.lsp.enable('lua_ls')

vim.lsp.config('rust_analyzer', {
    cmd = {"rustup", "run", "stable", "rust-analyzer"},
    on_attach = on_attach,
})
vim.lsp.enable('rust_analyzer')
