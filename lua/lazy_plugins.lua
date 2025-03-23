return {
    {
        "echasnovski/mini.nvim",
        version = false,
        config = function()
            require("mini.ai").setup()
            require("mini.move").setup({
                mappings = {
                    down = '<M-j>',
                    up = '<M-k>',
                    left = '',
                    right = '',

                    -- Move current line in Normal mode
                    line_left = '',
                    line_right = '',
                    line_down = '',
                    line_up = '',
                },
            })
            require("mini.comment").setup()
            require("mini.surround").setup()
            require("mini.indentscope").setup()
            require("mini.notify").setup()
            require("mini.sessions").setup()
            require("mini.pairs").setup()
            require("mini.statusline").setup({
              use_icons = false,
              content = {
                active = function()
                  local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
                  local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
                  local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
                  local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120, use_icons = true })
                  local location      = MiniStatusline.section_location({ trunc_width = 75 })

                  return MiniStatusline.combine_groups({
                    { hl = mode_hl,                  strings = { mode } },
                    { hl = 'MiniStatuslineDevinfo',  strings = { diagnostics } },
                    '%<', -- Mark general truncate point
                    { hl = 'MiniStatuslineFilename', strings = { filename } },
                    '%=', -- End left alignment
                    { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
                    { hl = mode_hl,                  strings = { location } },
                  })
                end,
              }
            })
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },

    "nvim-lua/plenary.nvim",

    "folke/tokyonight.nvim",

    {
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").setup({
                compile = true,
            })
        end,
    },

    "loctvl842/monokai-pro.nvim",

    "gbprod/nord.nvim",

    "L3MON4D3/LuaSnip",

    {
        "nvim-telescope/telescope.nvim",
        keys = {
            { "<leader>r", require("telescope.builtin").oldfiles, desc = "Find recently opened files" },
            { "<leader>bf", require("telescope.builtin").buffers, desc = "Find in buffers" },
            { "<leader>bj", require("telescope.builtin").jumplist, desc = "Find in buffers" },
        },
        opts = {
            pickers = {
                buffers = {
                    mappings = {
                        i = {
                          ["<c-d>"] = require("telescope.actions").delete_buffer
                        }
                    }
                }
            }
        },
    },


    {
        "junegunn/fzf.vim",
        config = function()
            vim.keymap.set("n", "<C-p>", ":Files<cr>")
            vim.keymap.set("n", "<M-p>", ":Files %:h<cr>", { noremap = true })
            vim.g.fzf_preview_window = ""
        end,
    },

    {
        "gbprod/yanky.nvim",
        config = function()
            vim.keymap.set("n", "<F2>", ":Telescope yank_history<cr>", { silent = true, noremap = true })
            require("telescope").load_extension("yank_history")
            require("yanky").setup({
              picker = {
                select = {
                  action = nil, -- nil to use default put action
                },
                telescope = {
                  mappings = nil, -- nil to use default mappings
                },
                system_clipboard = {
                    sync_with_ring = false,
                },
              },
            })
        end,
    },

    {
        "mileszs/ack.vim",
        init = function()
            if vim.fn.executable("rg") then
                vim.g.ackprg = "rg --vimgrep"
            end
        end,
        keys = {
            { "<leader>a.", ":Ack!<Space>", { noremap = true } },
            { "<leader>ad", ":Ack!<Space><Space>%:p:h<left><left><left><left><left><left>", { noremap = true } },
        },
    },

    "mbbill/undotree",

    {
        "nathangrigg/vim-beancount",
        ft = "beancount",
    },

    {
        "aliva/vim-fish",
        ft = "fish",
    },

    {
        "ray-x/go.nvim",
        ft = "go",
        config = function()
            require("go").setup({
                comment_placeholder = "",
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function(_)
                    require("go.format").goimports()
                end
            })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "go",
                callback = function(_)
                    vim.keymap.set("n", "<C-w>x", ":GoAltV<cr>", { noremap = true })
                end
            })
        end,
    },

    "ray-x/guihua.lua",
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {"hiphish/rainbow-delimiters.nvim"},
        config = function()
            require("nvim-treesitter.configs").setup({
                modules = {},
                auto_install = false,
                sync_install = false,
                ignore_install = {},
                ensure_installed = { "go", "lua", "comment", "vim", "objc" },
                highlight = {
                    enable = true,
                },
                rainbow = {
                    enable = true,
                },
            })
        end
    },

    {
        "sindrets/diffview.nvim",
        config = function()
            require("diffview").setup({
                use_icons = false,
                view = {
                    merge_tool = {
                        layout = "diff4_mixed",
                    }
                }
            })
        end,
    },

    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({
                view_options = {
                    show_hidden = true,
                },
            })

            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end,
    },

-- {{{ File Types
    {
        "hashivim/vim-terraform",
        ft = "terraform",
        config = function()
            vim.g.terraform_completion_keys = 1
            vim.g.terraform_align = 1
            vim.g.terraform_fmt_on_save = 1
            vim.g.terraform_registry_module_completion = 0
        end,
    },

    {
        "keith/swift.vim",
        ft = "swift",
    },

    {
        "leafgarland/typescript-vim",
        ft = "typescript",
    },

    {
        "rust-lang/rust.vim",
        ft = "rust",
        config = function()
            vim.g.rustfmt_autosave = 1
        end,
    },
-- }}}

---{{{ LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "j-hui/fidget.nvim",
                config = function()
                    require("fidget").setup({})
                end,
            },
        },
    },

    {
        "hrsh7th/nvim-cmp",
        config = function()
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
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = {
                    { name = "nvim_lua" },
                    { name = "nvim_lsp" },
                    { name = "buffer", keyword_length = 5 },
                    { name = "beancount" },
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
        end,
    },

    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "crispgm/cmp-beancount",
    "ray-x/lsp_signature.nvim",
--- }}}
}
