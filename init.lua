-- Basic {{{
vim.o.shell = '/bin/bash'
vim.o.updatetime = 300
vim.o.mouse = ''
vim.g.mapleader = ','
vim.g.maplocalleader = '\\'
vim.o.expandtab = true
vim.o.foldmethod = 'marker'
vim.o.whichwrap = vim.o.whichwrap .. '<,>,h,l'
vim.o.splitright = true
-- }}}

-- Display {{{
vim.o.background = 'light'
vim.o.scrolloff = 4
vim.o.number = true
vim.o.textwidth = 0
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.wrap = false
vim.o.showmatch = true
vim.o.showcmd = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.colorcolumn = '+0'
vim.o.showtabline = 2

vim.api.nvim_set_hl(0, 'WhiteSpaceEOL', {ctermbg='red'})
vim.fn.matchadd('WhiteSpaceEOL', '\\s\\+$')
-- }}}

-- Command Mode {{{
vim.o.cmdheight = 2
vim.o.matchtime = 2
vim.o.laststatus = 2
vim.o.wildmode = 'longest,list'
vim.o.wildignore = '*.pyc'
-- }}}

-- Search {{{
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.magic = true
-- }}}

-- Bell {{{
vim.o.errorbells = false
vim.o.visualbell = false
-- }}}

-- Mapping {{{
vim.keymap.set({'n', 'v'}, '<Up>', 'gk', { noremap = true })
vim.keymap.set({'n', 'v'}, '<Down>', 'gj', { noremap = true })
vim.keymap.set('i', '<Up>', '<C-o>gk', { noremap = true })
vim.keymap.set('i', '<Down>', '<C-o>gj', { noremap = true })

vim.keymap.set('n', '<leader><space>', ':noh<cr>', { silent = true, noremap = true })
vim.keymap.set('n', '<C-t>', ':tabnew<cr>', { silent = true, noremap = true })
vim.keymap.set('n', '<C-s>', ':w<cr>', { noremap = true })
vim.keymap.set('i', '<C-s>', '<esc>:w<cr>', { noremap = true })

-- window switching keymaps
vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true, noremap = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true, noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true, noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true, noremap = true })

-- Emacs-compatible keys
vim.keymap.set('c', '<C-a>', '<home>', { noremap = true })
vim.keymap.set('c', '<C-e>', '<end>', { noremap = true })
vim.keymap.set('i', '<C-a>', '<C-o>^', { noremap = true })
vim.keymap.set('i', '<C-e>', '<C-o>$', { noremap = true })
vim.keymap.set('i', '<C-k>', '<C-o>D', { noremap = true })
vim.keymap.set('i', '<C-b>', '<C-o>h', { noremap = true })
vim.keymap.set('i', '<C-f>', '<C-o>l', { noremap = true })
vim.keymap.set('i', '<C-d>', '<C-o>x', { noremap = true })
-- }}}

-- File Type {{{
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'make', 'gitconfig'},
    callback = function(args)
        vim.o.expandtab = false
    end
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'objc', 'coffee', 'html', 'css', 'scss', 'ruby', 'eruby', 'yaml'},
    callback = function(args)
        vim.o.tabstop = 2
        vim.o.softtabstop = 2
        vim.o.shiftwidth = 2
    end
})
vim.api.nvim_create_autocmd('BufWritePre', {
    command = [[%s/\s\+$//e]],
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'beancount'},
    callback = function(args)
        vim.keymap.set({'n', 'v'}, '<leader>.', ':AlignCommodity<CR>', { noremap = true })
    end
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'qf'},
    callback = function(args)
        vim.keymap.set('n', 't', '<C-W><Enter><C-W>T', { noremap = true, buffer = true, desc = 'open selected line in a new tab' })
    end
})
-- }}}

-- Plugins {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    {
        'ervandew/supertab',
        config = function()
            vim.g.SuperTabMappingForward = '<s-tab>'
            vim.g.SuperTabMappingBackward = '<tab>'
        end,
    },

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
            {"<leader>c<space>", 'NERDCommenterToggle', {"n", "v"}},
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
            if vim.fn['system']("uname -m") == "arm64\n" then
                vim.opt.rtp:append('/opt/homebrew/opt/fzf')
            else
                vim.opt.rtp:append('/usr/local/opt/fzf')
            end
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
        config = function()
            if vim.fn.executable('rg') then
                vim.g.ackprg = 'rg --vimgrep'
            end
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
                ensure_installed = { "go" },
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

    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/nvim-cmp',
    'ray-x/lsp_signature.nvim',
})
-- }}}

-- LSP {{{
local nvim_lsp = require('lspconfig')
local lsp_handlers = require('lsp_handlers')

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true, buffer = bufnr }

  vim.keymap.set('n', 'gdd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gdt', function()
      vim.cmd('tab split')
      vim.lsp.buf.definition()
  end, opts)
  vim.keymap.set('n', 'gds', function()
      vim.cmd('vsplit')
      vim.lsp.buf.definition()
  end, opts)
  vim.keymap.set('n', 'gi', function()
      vim.cmd('tab split')
      lsp_handlers.goto_implementations()
  end, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'cn', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, ops)

  require("lsp_signature").on_attach({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "rounded"
      }
  })
end

local util = require 'lspconfig.util'

nvim_lsp.gopls.setup{
    on_attach = on_attach,
    root_dir = util.root_pattern("go.mod", "doc.go"),
}

require('fidget').setup()

local cmp = require('cmp')
cmp.setup {
  completion = {
    autocomplete = false,
    completeopt = "menu,noselect",
    keyword_length = 2,
  },
  preselect = "none",
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
  }
}

vim.api.nvim_create_autocmd({'TextChanged', 'TextChangedI', 'TextChangedP'}, {
    callback = function(args)
        local cursor = vim.api.nvim_win_get_cursor(0)
        local line = vim.api.nvim_get_current_line()
        if string.sub(line, cursor[2], cursor[2]) == "." then
          cmp.complete()
        end
    end
})
-- }}}

vim.o.background = 'dark'
vim.cmd.colorscheme('tokyonight')

-- Tab {{{
local current_tab = 0
local last_tab = 0
vim.api.nvim_create_autocmd({'TabEnter', 'TabLeave'}, {
    callback = function(args)
        current_tab = vim.api.nvim_tabpage_get_number(0)
        last_tab = vim.fn['tabpagenr']('$')
    end
})
vim.api.nvim_create_autocmd('TabClosed', {
    callback = function(args)
        print(current_tab, last_tab)
        if current_tab > 1 and current_tab < last_tab then
            vim.cmd('tabp')
        end
    end
})
-- }}}
