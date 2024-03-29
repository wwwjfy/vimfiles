return {
    "nvim-lua/plenary.nvim",

    {
        "nathanaelkane/vim-indent-guides",
        config = function()
            vim.api.nvim_set_hl(0, "IndentGuidesOdd", {ctermbg="black"})
            vim.api.nvim_set_hl(0, "IndentGuidesEven", {ctermbg="darkgrey"})
            vim.g.indent_guides_guide_size = 1
            vim.g.indent_guides_start_level = 2
            vim.g.indent_guides_default_mapping = 0
            vim.call("indent_guides#enable")
        end,
    },

    "altercation/vim-colors-solarized",
    "folke/tokyonight.nvim",
    "rebelot/kanagawa.nvim",
    "gbprod/nord.nvim",

    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },

    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({
                fast_wrap = {},
            })
        end,
    },

    {
        "nvim-tree/nvim-tree.lua",
        keys = {
            {"<leader>gt", function()
                require("nvim-tree.api").tree.toggle({ find_file = true, focus = true })
            end, { desc = "open nvim tree" }}
        },
        config = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            require("nvim-tree").setup()
            require("nvim-tree").config.renderer.icons.show = {}
        end,
    },

    {
        "L3MON4D3/LuaSnip",
    },

    {
        "nvim-telescope/telescope.nvim",
        config = function()
            vim.keymap.set("n", "<leader>r", require("telescope.builtin").oldfiles, { desc = "Find recently opened files" })
            vim.keymap.set("n", "<leader>bf", require("telescope.builtin").buffers, { desc = "Find in buffers" })
            vim.keymap.set("n", "<leader>bj", require("telescope.builtin").jumplist, { desc = "Find in buffers" })
        end,
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
        "vim-airline/vim-airline",
        config = function()
            vim.g["airline#extensions#branch#enabled"] = 0
        end,
    },

    {
        "tmhedberg/SimpylFold",
        ft = "python",
        config = function()
            vim.g.SimpylFold_fold_docstring = 0
        end,
    },

    "wwwjfy/numbered-tabline",

    {
        "mileszs/ack.vim",
        init = function()
            if vim.fn.executable("rg") then
                vim.g.ackprg = "rg --vimgrep"
            end
        end,
        config = function()
            vim.keymap.set("n", "<Leader>a.", ":Ack!<Space>", { noremap = true })
            vim.keymap.set("n", "<Leader>ad", ":Ack!<Space><Space>%:p:h<left><left><left><left><left><left>", { noremap = true })
        end,
    },

    "mbbill/undotree",
    "jlanzarotta/bufexplorer",
    "ruanyl/vim-gh-line",
    "tpope/vim-fugitive",

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
                max_line_len = 3000,
                goimport = "golines",
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function(_)
                    require("go.format").goimport()
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
        dependencies = {"HiPhish/nvim-ts-rainbow2"},
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "go", "lua", "comment", "vim" },
                highlight = {
                    enable = true,
                },
                rainbow = {
                    enable = true,
                },
            })
        end
    },

    "nvim-treesitter/playground",

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
            "j-hui/fidget.nvim",
        },
    },

    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "ray-x/lsp_signature.nvim",
--- }}}
}
