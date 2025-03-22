local function transform_git_url(remote)
  local patterns = {
      "^([^@]+)@([^:/]+):(.+)$",
      "^()([^:/]+):(.+)$",
  }

  for _, pattern in ipairs(patterns) do
      local _, host, path = remote:match(pattern)
      if host and path then
          return "https://" .. host .. "/" .. path:gsub("%.git$", "")  -- Remove .git extension (optional)
      end
  end

  return remote:gsub(".git$", "")
end

local open_command = (function()
    if vim.fn.has('win16') == 1 or vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
      return 'start'
    elseif vim.fn.has('mac') == 1 or vim.fn.has('macunix') == 1 or vim.fn.has('gui_macvim') == 1 then
      return 'open'
    elseif vim.fn.executable('xdg-open') == 1 then
      return 'xdg-open'
    end
    return ''
end)()

local notify_in_main = vim.schedule_wrap(function (message, level)
    vim.notify(message, level)
end)

local function async_system(cmd, opts)
    local co = coroutine.running()

    vim.system(cmd, opts, function (result)
        if result.code ~= 0 then
            notify_in_main(result.stderr, vim.log.levels.WARN)
            coroutine.resume(co, false, "")
            return
        end

        coroutine.resume(co, true, result.stdout)
    end)

    return coroutine.yield()
end

local function async_open_line(line_num)
    -- 1. get remote
    -- 2. get path
    -- 3. form the url
    -- 4. open it

    if open_command == '' then
        notify_in_main("Unrecognized system, I don't know how to open a url")
        return
    end

    local file_path = vim.api.nvim_buf_get_name(0)
    local folder_path = vim.fn.fnamemodify(file_path, ":h")

    local stdout, success = "", false

    -- get remote
    success, stdout = async_system({ "git", "remote" }, { cwd = folder_path })
    if not success then
        return
    end
    -- use first remote
    local remotes = vim.split(stdout, "\n", { trimempty = true })
    if #remotes == 0 then
        notify_in_main("This repo doesn't have any remote")
        return
    end
    success, stdout = async_system({ "git", "config", "--get", "remote." .. remotes[1] .. ".url"}, { cwd = folder_path })
    if not success then
        return
    end
    local git_remote = transform_git_url(vim.trim(stdout))

    -- get commit
    success, stdout = async_system({ "git", "rev-parse", "HEAD" }, { cwd = folder_path })
    if not success then
        return
    end
    local git_commit = vim.trim(stdout)

    success, stdout = async_system({ "git", "rev-parse", "--show-toplevel" }, { cwd = folder_path })
    if not success then
        return
    end

    local git_root = vim.trim(stdout)
    local relative_path = file_path:sub(#git_root + 1)

    local url = string.format("%s/blob/%s%s#L%d", git_remote, git_commit, relative_path, line_num)

    async_system({ open_command, url })
end

local function open_line()
    coroutine.resume(coroutine.create(async_open_line), vim.api.nvim_win_get_cursor(0)[1])
end

vim.keymap.set('n', "<leader>gh", open_line, { silent = true })
