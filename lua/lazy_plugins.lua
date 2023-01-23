return {
    {
        'nathanaelkane/vim-indent-guides',
        config = function()
            vim.api.nvim_set_hl(0, 'IndentGuidesOdd', {ctermbg='black'})
            vim.api.nvim_set_hl(0, 'IndentGuidesEven', {ctermbg='darkgrey'})
            vim.g.indent_guides_guide_size = 1
            vim.g.indent_guides_start_level = 2
            vim.g.indent_guides_enable_on_vim_startup = 1
        end,
    },

    'altercation/vim-colors-solarized',
    'folke/tokyonight.nvim',

    {
        'scrooloose/nerdcommenter',
        keys = {
            {"<leader>c<space>", 'NERDCommenterToggle', mode = {"n", "v"}},
        },
    },

    {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup({
                fast_wrap = {},
            })
        end,
    },

    {
        'nvim-tree/nvim-tree.lua',
        config = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            require("nvim-tree").setup()
        end,
    },

    'nvim-lua/plenary.nvim',

    {
        'nvim-telescope/telescope.nvim',
        config = function()
            vim.keymap.set('n', '<leader>r', require('telescope.builtin').oldfiles, { desc = 'Find recently opened files' })
            vim.keymap.set('n', '<leader>bf', require('telescope.builtin').buffers, { desc = 'Find in buffers' })
        end,
    },

    {
        'junegunn/fzf.vim',
        config = function()
            vim.keymap.set('n', '<C-p>', ':Files<cr>')
            vim.keymap.set('n', '<M-p>', ':Files %:h<cr>', { noremap = true })
            vim.g.fzf_preview_window = ''
        end,
    },

    {
        'gbprod/yanky.nvim',
        config = function()
            vim.keymap.set('n', '<F2>', ':Telescope yank_history<cr>', { silent = true, noremap = true })
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
        'vim-airline/vim-airline',
        config = function()
            vim.g['airline#extensions#branch#enabled'] = 0
        end,
    },

    {
        'tmhedberg/SimpylFold',
        config = function()
            vim.g.SimpylFold_fold_docstring = 0
        end,
    },

    'wwwjfy/numbered-tabline',

    {
        'mileszs/ack.vim',
        init = function()
            if vim.fn.executable('rg') then
                vim.g.ackprg = 'rg --vimgrep'
            end
        end,
        config = function()
            vim.keymap.set('n', '<Leader>a.', ':Ack!<Space>', { noremap = true })
            vim.keymap.set('n', '<Leader>ad', ':Ack!<Space><Space>%:p:h<left><left><left><left><left><left>', { noremap = true })
        end,
    },

    'mbbill/undotree',
    'jlanzarotta/bufexplorer',
    'ruanyl/vim-gh-line',
    'tpope/vim-fugitive',
    'nathangrigg/vim-beancount',

    {
        'aliva/vim-fish',
        ft = 'fish',
    },

    {
        'ray-x/go.nvim',
        ft = 'go',
        config = function()
            require('go').setup({
                comment_placeholder = '',
                max_line_len = 3000,
                goimport = 'golines',
            })
            vim.api.nvim_create_autocmd('BufWritePre', {
                pattern = '*.go',
                callback = function(args)
                    require('go.format').goimport()
                end
            })
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'go',
                callback = function(args)
                    vim.keymap.set('n', '<C-w>x', ':GoAltV<cr>', { noremap = true })
                end
            })
        end,
    },

    'ray-x/guihua.lua',
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {'p00f/nvim-ts-rainbow'},
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { "go", "lua", "comment" },
                highlight = {
                    enable = true,
                },
                rainbow = {
                    enable = true,
                },
            })
        end
    },

    'nvim-treesitter/playground',

    {
        'sindrets/diffview.nvim',
        config = function()
            require('diffview').setup({
                view = {
                    merge_tool = {
                        layout = 'diff4_mixed',
                    }
                }
            })
        end,
    },

-- {{{ File Types
    {
        'hashivim/vim-terraform',
        config = function()
            vim.g.terraform_completion_keys = 1
            vim.g.terraform_align = 1
            vim.g.terraform_fmt_on_save = 1
            vim.g.terraform_registry_module_completion = 0
        end,
    },

    'keith/swift.vim',
    'leafgarland/typescript-vim',

    {
        'rust-lang/rust.vim',
        config = function()
            vim.g.rustfmt_autosave = 1
        end,
    },
-- }}}

    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'j-hui/fidget.nvim',
        },
    },

    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'ray-x/lsp_signature.nvim',
}
