local min_width_of_tab = 10

local function get_tab_label(n)
  local buflist = vim.fn.tabpagebuflist(n)
  local winnr = vim.fn.tabpagewinnr(n)
  local filename = vim.fn.bufname(buflist[winnr])
  local label = string.format(" %d %s ", n, (filename == '' and '[No Name]' or vim.fn.fnamemodify(filename, ':t')))

  if vim.fn.getbufvar(buflist[winnr], '&modified') == 1 then
    label = label .. '[+]'
  end

  return label
end

function numberred_tabline()
  local nr_current = vim.fn.tabpagenr()
  local nr_total = vim.fn.tabpagenr('$')
  local mark_left = ''
  local mark_right = ''
  local labels = {}
  local lengths = {}
  local total_length = 0
  local flexibility = 0 -- how many cols can be gained if we shrink all tabs to min
  local flexible = {} -- indices of tabs that can be shrunk

  -- Collect information about tabs
  for i = 1, nr_total do  -- 0-based loop to match original algorithm
    local label = get_tab_label(i)  -- convert to 1-based for Vim functions
    labels[i] = label
    local length = vim.fn.strwidth(label)  -- Use strwidth instead of string.len for multibyte support
    lengths[i] = length
    total_length = total_length + length

    if length > min_width_of_tab then
      flexibility = flexibility + (length - min_width_of_tab)
      flexible[#flexible+1] = i
    end
  end

  -- Copy lengths to limits
  local limits = {}
  for i = 1, nr_total do
    limits[i] = lengths[i]
  end

  local columns = vim.o.columns

  -- Check if we need to adjust tab widths
  if total_length <= columns then
    -- All tabs fit, do nothing
  elseif total_length - flexibility <= columns then
    -- Shrink some tabs
    local last_width = min_width_of_tab
    local next_width = last_width

    if #flexible > 0 then
      next_width = next_width + math.floor((columns - total_length + flexibility) / #flexible)
    end

    local new_flexible = {}

    for _, i in ipairs(flexible) do
      local possible = lengths[i]
      if possible <= next_width then
        limits[i] = possible
      else
        total_length = total_length - (limits[i] - next_width)
        limits[i] = next_width
        table.insert(new_flexible, i)
      end
    end

    -- Expand some tabs to use all space
    flexible = new_flexible
    while total_length < columns and #flexible > 0 do
      local step = math.floor((columns - total_length) / #flexible)
      next_width = next_width + (step > 0 and step or 1)
      new_flexible = {}

      for _, i in ipairs(flexible) do
        local possible = lengths[i]
        if possible <= next_width then
          total_length = total_length + (possible - limits[i])
          limits[i] = possible
        else
          total_length = total_length + (next_width - limits[i])
          limits[i] = next_width
          if total_length >= columns then
            break
          end
          table.insert(new_flexible, i)
        end
      end

      flexible = new_flexible
    end
  else
    -- Need to shrink all tabs and shift position to show current one
    -- First, shrink all tabs to min
    total_length = 0
    for i = 1, nr_total do
      local l = math.min(lengths[i], min_width_of_tab)
      limits[i] = l
      total_length = total_length + l
    end

    -- Second, remove some tabs completely
    local first = 1
    local last = nr_total
    while total_length > columns and first <= last do
      local one = math.abs(first - nr_current) > math.abs(nr_current - last) and first or last
      if one == nr_current then
        local need = total_length - columns
        limits[one] = math.max(4, limits[one] - need)  -- Ensure at least 4 width
        total_length = total_length - (need - math.max(0, 4 - (limits[one] + need)))
        break
      end

      total_length = total_length - limits[one]
      limits[one] = 0

      if one == first then
        first = first + 1
        total_length = total_length + string.len('<') - string.len(mark_left)
        mark_left = '<'
      else
        last = last - 1
        total_length = total_length + string.len('>') - string.len(mark_right)
        mark_right = '>'
      end
    end

    -- Rebuild flexible list from current limits
    flexible = {}
    for i = 0, nr_total - 1 do
      if limits[i] > 0 and limits[i] < lengths[i] then
        table.insert(flexible, i)
      end
    end

    -- Third, expand the remaining tabs to use all space
    while total_length < columns and #flexible > 0 do
      local new_flexible = {}
      for _, i in ipairs(flexible) do
        if limits[i] == 0 or limits[i] >= lengths[i] then
        else
            limits[i] = limits[i] + 1
            total_length = total_length + 1

            if limits[i] < lengths[i] then
              table.insert(new_flexible, i)
            end

            if total_length >= columns then
              break
            end
        end
      end

      if #new_flexible == 0 then break end
      flexible = new_flexible
    end
  end

  -- Build the tabline string
  local s = '%#TabLine#' .. mark_left

  for i = 1, nr_total do
    if limits[i] < 4 then
    else
        -- Select the highlighting
        s = s .. (i == nr_current and '%#TabLineSel#' or '%#TabLine#')

        local l = limits[i]
        if l >= lengths[i] - 1 then
          s = s .. string.sub(labels[i], 1, l)
        else
          s = s .. string.sub(labels[i], 1, l-2) .. '~ '
        end
    end
  end

  -- After the last tab fill with TabLineFill and reset tab page nr
  s = s .. (string.len(mark_right) > 0 and '%#TabLine#' .. mark_right or '%#TabLineFill#%T')

  return s
end

vim.opt.tabline = '%!v:lua.numberred_tabline()'
