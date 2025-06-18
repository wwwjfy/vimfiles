local M = {}

local function execute_grep(pattern, directory, extra_args)
    if not pattern or pattern == "" then
        print("No search pattern provided")
        return
    end

    local cmd = {"xg", "--vimgrep", "--color=never"}

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

vim.keymap.set("n", "<leader>a.", M.grep_global, { noremap = true, desc = "Grep globally" })
vim.keymap.set("n", "<leader>ad", M.grep_current_dir, { noremap = true, desc = "Grep in current directory" })

vim.api.nvim_create_user_command("Grep", function(opts)
    M.grep(opts.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command("GrepDir", function(opts)
    local args = vim.split(opts.args, " ", { trimempty = true })
    local pattern = args[1]
    local directory = args[2] or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
    M.grep(pattern, directory)
end, { nargs = "+" })

return M
