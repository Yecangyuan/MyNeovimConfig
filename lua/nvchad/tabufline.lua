local M = {}

-- Navigate to next buffer
M.next = function()
  if vim.t.bufs and #vim.t.bufs > 0 then
    local current_buf = vim.api.nvim_get_current_buf()
    local current_idx = nil
    
    -- Find current buffer index
    for i, buf in ipairs(vim.t.bufs) do
      if buf == current_buf then
        current_idx = i
        break
      end
    end
    
    -- Go to next buffer
    if current_idx then
      local next_idx = current_idx + 1
      if next_idx > #vim.t.bufs then
        next_idx = 1
      end
      vim.api.nvim_set_current_buf(vim.t.bufs[next_idx])
    end
  else
    -- Fallback to native buffer navigation
    vim.cmd("bnext")
  end
end

-- Navigate to previous buffer
M.prev = function()
  if vim.t.bufs and #vim.t.bufs > 0 then
    local current_buf = vim.api.nvim_get_current_buf()
    local current_idx = nil
    
    -- Find current buffer index
    for i, buf in ipairs(vim.t.bufs) do
      if buf == current_buf then
        current_idx = i
        break
      end
    end
    
    -- Go to previous buffer
    if current_idx then
      local prev_idx = current_idx - 1
      if prev_idx < 1 then
        prev_idx = #vim.t.bufs
      end
      vim.api.nvim_set_current_buf(vim.t.bufs[prev_idx])
    end
  else
    -- Fallback to native buffer navigation
    vim.cmd("bprevious")
  end
end

-- Close current buffer
M.close_buffer = function()
  local current_buf = vim.api.nvim_get_current_buf()
  
  -- Remove from vim.t.bufs if exists
  if vim.t.bufs then
    for i, buf in ipairs(vim.t.bufs) do
      if buf == current_buf then
        table.remove(vim.t.bufs, i)
        break
      end
    end
  end
  
  -- Close the buffer
  vim.cmd("bdelete " .. current_buf)
  
  -- Switch to another buffer if available
  if vim.t.bufs and #vim.t.bufs > 0 then
    vim.api.nvim_set_current_buf(vim.t.bufs[1])
  end
end

-- Close all other buffers
M.closeOtherBufs = function()
  local current_buf = vim.api.nvim_get_current_buf()
  
  if vim.t.bufs then
    for _, buf in ipairs(vim.t.bufs) do
      if buf ~= current_buf then
        pcall(vim.cmd, "bdelete " .. buf)
      end
    end
    vim.t.bufs = { current_buf }
  end
end

-- Move buffer in the list
M.move_buf = function(direction)
  if not vim.t.bufs or #vim.t.bufs < 2 then
    return
  end
  
  local current_buf = vim.api.nvim_get_current_buf()
  local current_idx = nil
  
  for i, buf in ipairs(vim.t.bufs) do
    if buf == current_buf then
      current_idx = i
      break
    end
  end
  
  if not current_idx then
    return
  end
  
  -- direction: 2 = left, 4 = right (following NvChad convention)
  local new_idx
  if direction == 2 then -- move left
    new_idx = current_idx - 1
    if new_idx < 1 then
      new_idx = #vim.t.bufs
    end
  else -- move right
    new_idx = current_idx + 1
    if new_idx > #vim.t.bufs then
      new_idx = 1
    end
  end
  
  -- Swap buffers
  vim.t.bufs[current_idx], vim.t.bufs[new_idx] = vim.t.bufs[new_idx], vim.t.bufs[current_idx]
end

return M
