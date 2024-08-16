local M = {}

-- 高亮组名和命名空间
local highlight_group = "MyFindReplaceHighlight"
local ns_id = vim.api.nvim_create_namespace(highlight_group)
local prompt = "Find & Replace: "
local dialog_open = false -- 追踪对话框是否已经打开

-- 创建高亮组
vim.cmd("highlight " .. highlight_group .. " ctermbg=yellow ctermfg=black guibg=yellow guifg=black")

-- 创建输入对话框缓冲区
function M.create_input_dialog()
  -- if dialog_open then
  --   vim.api.nvim_win_close(M.input_win, true)
  --   if vim.api.nvim_buf_is_valid(M.input_buf) then
  --     vim.api.nvim_buf_delete(M.input_buf, { force = true })
  --   end
  -- else
  -- 创建一个不可修改的缓冲区
  local buf = vim.api.nvim_create_buf(false, true)

  -- 配置浮动窗口的选项
  local width = 50
  local height = 1
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local opts = {
    style = "minimal",
    relative = "cursor",
    width = width,
    height = height,
    row = row + 1,
    col = col - math.floor(width / 2),
    border = "single",
  }

  -- 打开浮动窗口
  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_buf_set_option(buf, "buftype", "prompt")
  vim.fn.prompt_setprompt(buf, prompt)
  vim.cmd [[startinsert]]

  -- 绑定 <Enter> 键执行查找替换
  vim.api.nvim_buf_set_keymap(
    buf,
    "i",
    "<CR>",
    [[<C-\><C-n>:lua require('lua.configs.utility.findreplace').on_enter()<CR>]],
    { noremap = true, silent = true }
  )

  -- 保存窗口和缓冲区 ID，稍后可以清理
  M.input_win = win
  M.input_buf = buf
end

-- 处理用户按下 <Enter> 键后的行为
function M.on_enter()
  local input = vim.api.nvim_get_current_line():sub(#prompt + 1)
  print(input)

  -- 提取查找和替换的内容，假设用户输入格式为 "find replace"
  local args = vim.split(input, " ", { plain = true })

  if #args < 2 then
    print "Please enter in the format: <find> <replace>"
    return
  end

  dialog_open = false -- 更新状态为已关闭
  -- 关闭输入框
  vim.api.nvim_win_close(M.input_win, true)

  -- 删除缓冲区
  if vim.api.nvim_buf_is_valid(M.input_buf) then
    vim.api.nvim_buf_delete(M.input_buf, { force = true })
  end

  -- 执行查找和替换
  M.global_replace(args[1], table.concat(args, " ", 2))
end

-- 查找并替换函数
function M.replace_in_buffer(buffer, search, replace)
  -- 获取缓冲区中的所有行
  local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)

  -- 清除之前的高亮
  vim.api.nvim_buf_clear_namespace(buffer, ns_id, 0, -1)

  -- 遍历每一行进行查找和替换
  for i, line in ipairs(lines) do
    local new_line = line
    local start_pos = 1

    -- 查找所有匹配项并高亮
    while true do
      local s, e = new_line:find(search, start_pos)
      if not s then
        break
      end

      -- 高亮匹配的部分
      vim.api.nvim_buf_add_highlight(buffer, ns_id, highlight_group, i - 1, s - 1, e)

      -- 进行替换
      new_line = new_line:sub(1, s - 1) .. replace .. new_line:sub(e + 1)

      -- 更新起始位置以避免无限循环，并确保正确处理重叠匹配
      start_pos = s + #replace
    end

    -- 更新行内容
    lines[i] = new_line
  end

  -- 将替换后的内容写回缓冲区
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
end

-- 全局查找并替换函数
function M.global_replace(search, replace)
  -- 获取所有打开的缓冲区
  local buffers = vim.api.nvim_list_bufs()

  -- 遍历每一个缓冲区进行替换
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buf) then
      M.replace_in_buffer(buf, search, replace)
    end
  end

  -- print "Global replace completed."
end

-- 创建 Neovim 用户命令
function M.setup()
  vim.api.nvim_create_user_command("FindReplace", function()
    M.create_input_dialog()
  end, {})
end

return M
