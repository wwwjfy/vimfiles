-- Basic {{{
vim.o.shell = "/bin/bash"
vim.o.updatetime = 300
vim.o.mouse = ""
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"
vim.o.expandtab = true
vim.o.foldmethod = "marker"
vim.o.whichwrap = vim.o.whichwrap .. "<,>,h,l"
vim.o.splitright = true
-- }}}

-- Display {{{
vim.o.background = "light"
vim.o.scrolloff = 4
vim.o.number = true
vim.o.relativenumber = true
vim.o.textwidth = 0
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.wrap = false
vim.o.showmatch = true
vim.o.showcmd = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.colorcolumn = "+0"
vim.o.showtabline = 2
vim.o.termguicolors = true

vim.api.nvim_set_hl(0, "WhiteSpaceEOL", {ctermbg="red"})
vim.fn.matchadd("WhiteSpaceEOL", "\\s\\+$")
-- }}}

-- Command Mode {{{
vim.o.cmdheight = 2
vim.o.matchtime = 2
vim.o.laststatus = 2
vim.o.wildmode = "longest,list"
vim.o.wildignore = "*.pyc"
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
vim.keymap.set({"n", "v"}, "<Up>", "gk", { noremap = true })
vim.keymap.set({"n", "v"}, "<Down>", "gj", { noremap = true })
vim.keymap.set("i", "<Up>", "<C-o>gk", { noremap = true })
vim.keymap.set("i", "<Down>", "<C-o>gj", { noremap = true })

vim.keymap.set("n", "<leader><space>", ":noh<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<C-t>", ":tabnew<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<C-s>", ":w<cr>", { noremap = true })
vim.keymap.set("i", "<C-s>", "<esc>:w<cr>", { noremap = true })

vim.keymap.set("n", "<leader>q", ":q<cr>", { noremap = true })
vim.keymap.set("n", "<leader>tc", ":tabclose<cr>", { noremap = true })

-- window switching keymaps
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true, noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true, noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true, noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true, noremap = true })

-- quickfix switching keymaps
vim.keymap.set("n", "<M-j>", ":cnext<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<M-k>", ":cprev<cr>", { silent = true, noremap = true })

-- Emacs-compatible keys
vim.keymap.set("c", "<C-a>", "<home>", { noremap = true })
vim.keymap.set("c", "<C-e>", "<end>", { noremap = true })
vim.keymap.set("i", "<C-a>", "<C-o>^", { noremap = true })
vim.keymap.set("i", "<C-e>", "<C-o>$", { noremap = true })
vim.keymap.set("i", "<C-k>", "<C-o>D", { noremap = true })
vim.keymap.set("i", "<C-b>", "<C-o>h", { noremap = true })
vim.keymap.set("i", "<C-f>", "<C-o>l", { noremap = true })
vim.keymap.set("i", "<C-d>", "<C-o>x", { noremap = true })

-- copy/paste
vim.keymap.set("n", "<leader>yy", '"xyy')
vim.keymap.set("n", "<leader>p", '"xp')
vim.keymap.set("v", "<leader>y", '"xy')
vim.keymap.set("v", "<leader>p", '"xp')
-- }}}

-- File Type {{{
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"make", "gitconfig"},
    callback = function(_)
        vim.o.expandtab = false
    end
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"objc", "coffee", "html", "css", "scss", "ruby", "eruby", "yaml"},
    callback = function(_)
        vim.o.tabstop = 2
        vim.o.softtabstop = 2
        vim.o.shiftwidth = 2
    end
})
vim.api.nvim_create_autocmd("BufWritePre", {
    command = [[%s/\s\+$//e]],
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"beancount"},
    callback = function(_)
        vim.keymap.set({"n", "v"}, "<leader>.", ":AlignCommodity<CR>", { noremap = true })
    end
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"qf"},
    callback = function(_)
        vim.keymap.set("n", "t", "<C-W><Enter><C-W>T", { noremap = true, buffer = true, desc = "open selected line in a new tab" })
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

local fzf_rtp = function()
    local fzf_path = vim.fn["system"]("brew --prefix fzf")
    return string.sub(fzf_path, 1, #fzf_path - 1)
end

require("lazy").setup("lazy_plugins", {
    performance = {
        rtp = {
            paths = { fzf_rtp() },
        },
    },
    ui = {
        icons = {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },
})
-- }}}

-- Colorscheme {{{
vim.o.background = "dark"
vim.cmd.colorscheme("monokai-pro")
-- }}}

-- Tab {{{
local current_tab = 0
local last_tab = 0
vim.api.nvim_create_autocmd({"TabEnter", "TabLeave"}, {
    callback = function(_)
        current_tab = vim.api.nvim_tabpage_get_number(0)
        last_tab = vim.fn["tabpagenr"]("$")
    end
})
vim.api.nvim_create_autocmd("TabClosed", {
    callback = function(_)
        if current_tab > 1 and current_tab < last_tab then
            vim.cmd("tabp")
        end
    end
})
-- }}}
