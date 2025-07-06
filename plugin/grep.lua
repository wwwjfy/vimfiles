local M = {}

local function check_ripgrep()
    if vim.fn.executable("rg") == 0 then
        vim.notify("ripgrep (rg) is not installed or not in PATH.", vim.log.levels.ERROR, { title = "Grep Error" })
        return false
    end
    return true
end

local function execute_grep(pattern, directory, extra_args)
    if not pattern or pattern == "" then
        print("No search pattern provided")
        return
    end

    if not check_ripgrep() then
        return
    end

    local cmd = {"rg", "--vimgrep", "--color=never"}

    if extra_args then
        for _, arg in ipairs(extra_args) do
            table.insert(cmd, arg)
        end
    end

    table.insert(cmd, pattern)

    if directory then
        table.insert(cmd, directory)
    end

    local results = vim.fn.systemlist(cmd)

    if vim.v.shell_error ~= 0 then
        if #results == 0 then
            print("No matches found for: " .. pattern)
        else
            print("Search error: " .. table.concat(results, "\n"))
        end
        return
    end

    if #results == 0 then
        print("No matches found for: " .. pattern)
        return
    end

    local qf_entries = {}
    for _, line in ipairs(results) do
        local filename, lnum, col, text = line:match("([^:]+):(%d+):(%d+):(.*)")
        if filename and lnum and col and text then
            table.insert(qf_entries, {
                filename = filename,
                lnum = tonumber(lnum),
                col = tonumber(col),
                text = text:gsub("^%s+", "")
            })
        end
    end

    vim.fn.setqflist(qf_entries, "r")
    vim.cmd("copen")
    print(string.format("Found %d matches for: %s", #qf_entries, pattern))
end

function M.grep(pattern, directory)
    execute_grep(pattern, directory)
end

function M.grep_current_dir()
    local ok, pattern = pcall(vim.fn.input, "Grep in current dir: ")
    if ok and pattern and pattern ~= "" then
        local current_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
        execute_grep(pattern, current_dir)
    end
end

function M.grep_global()
    local ok, pattern = pcall(vim.fn.input, "Grep: ")
    if ok and pattern and pattern ~= "" then
        execute_grep(pattern)
    end
end

function M.grep_word(pattern, directory)
    execute_grep(pattern, directory, {"-w"})
end

function M.grep_word_current_dir()
    local ok, pattern = pcall(vim.fn.input, "Grep word in current dir: ")
    if ok and pattern and pattern ~= "" then
        local current_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
        execute_grep(pattern, current_dir, {"-w"})
    end
end

function M.grep_word_global()
    local ok, pattern = pcall(vim.fn.input, "Grep word: ")
    if ok and pattern and pattern ~= "" then
        execute_grep(pattern, nil, {"-w"})
    end
end

vim.keymap.set("n", "<leader>a.", M.grep_global, { noremap = true, desc = "Grep globally" })
vim.keymap.set("n", "<leader>ad", M.grep_current_dir, { noremap = true, desc = "Grep in current directory" })
vim.keymap.set("n", "<leader>aw.", M.grep_word_global, { noremap = true, desc = "Grep word globally" })
vim.keymap.set("n", "<leader>awd", M.grep_word_current_dir, { noremap = true, desc = "Grep word in current directory" })

return M
