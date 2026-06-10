-- 极速模式切换工具
-- 提供命令快速切换模式

local M = {}

local original_settings = {}

-- 当前模式
M.is_fast_mode = function()
  return vim.g.turbo_mode == true
end

-- 切换模式
M.toggle = function()
  if M.is_fast_mode() then
    M.disable()
  else
    M.enable()
  end
end

-- 启用极速模式
M.enable = function()
  print("🏎️  正在切换到极速模式...")

  -- 保存当前设置
  original_settings.cursorline = vim.o.cursorline
  original_settings.relativenumber = vim.o.relativenumber
  original_settings.number = vim.o.number
  original_settings.foldenable = vim.o.foldenable
  original_settings.mouse = vim.o.mouse
  original_settings.updatetime = vim.o.updatetime
  original_settings.timeoutlen = vim.o.timeoutlen
  original_settings.ttimeoutlen = vim.o.ttimeoutlen
  original_settings.scrolloff = vim.o.scrolloff
  original_settings.sidescrolloff = vim.o.sidescrolloff

  vim.g.turbo_mode = true

  -- 立即应用一些设置
  vim.o.cursorline = false
  vim.o.cursorcolumn = false
  vim.o.relativenumber = false
  vim.o.number = true
  vim.o.foldenable = false
  vim.o.mouse = ""
  vim.o.updatetime = 100
  vim.o.timeoutlen = 150
  vim.o.ttimeoutlen = 0
  vim.o.scrolloff = 0
  vim.o.sidescrolloff = 0

  -- 禁用 Treesitter 高亮（如果已加载）
  local ok, _ = pcall(require, "nvim-treesitter")
  if ok then
    vim.cmd("TSBufDisable highlight")
    vim.cmd("TSBufDisable indent")
    print("  ✓ Treesitter 高亮已禁用")
  end

  -- 禁用 indentline
  local ok2, ibl = pcall(require, "ibl")
  if ok2 then
    ibl.setup_buffer(0, { enabled = false })
    print("  ✓ 缩进线已禁用")
  end

  -- 禁用 gitsigns
  local ok3, gitsigns = pcall(require, "gitsigns")
  if ok3 then
    gitsigns.detach()
    print("  ✓ Git 标记已禁用")
  end

  print("✓ 已应用极速设置")
  print("⚠️  请运行 :Lazy sync 并重启 Neovim 以完全生效")
end

-- 禁用极速模式（恢复完整功能）
M.disable = function()
  print("正在恢复到完整功能模式...")

  -- 恢复设置（逐个设置以确保生效）
  if original_settings.cursorline ~= nil then
    vim.o.cursorline = original_settings.cursorline
  end
  if original_settings.relativenumber ~= nil then
    vim.o.relativenumber = original_settings.relativenumber
  end
  if original_settings.number ~= nil then
    vim.o.number = original_settings.number
  end
  if original_settings.foldenable ~= nil then
    vim.o.foldenable = original_settings.foldenable
  end
  if original_settings.mouse ~= nil then
    vim.o.mouse = original_settings.mouse
  end
  if original_settings.updatetime ~= nil then
    vim.o.updatetime = original_settings.updatetime
  end
  if original_settings.timeoutlen ~= nil then
    vim.o.timeoutlen = original_settings.timeoutlen
  end
  if original_settings.ttimeoutlen ~= nil then
    vim.o.ttimeoutlen = original_settings.ttimeoutlen
  end
  if original_settings.scrolloff ~= nil then
    vim.o.scrolloff = original_settings.scrolloff
  end
  if original_settings.sidescrolloff ~= nil then
    vim.o.sidescrolloff = original_settings.sidescrolloff
  end

  vim.g.turbo_mode = false

  -- 重新启用 Treesitter
  local ok, _ = pcall(require, "nvim-treesitter")
  if ok then
    vim.cmd("TSBufEnable highlight")
    vim.cmd("TSBufEnable indent")
  end

  print("✓ 已恢复设置")
  print("⚠️  请运行 :Lazy sync 并重启 Neovim 以完全生效")
end

-- 显示当前状态
M.status = function()
  local mode = M.is_fast_mode() and "🏎️  极速模式" or "🐌 完整功能模式"
  print("当前模式: " .. mode)
  print("")
  print("当前设置:")
  print("  cursorline: " .. tostring(vim.o.cursorline))
  print("  relativenumber: " .. tostring(vim.o.relativenumber))
  print("  updatetime: " .. vim.o.updatetime)
  print("  timeoutlen: " .. vim.o.timeoutlen)
end

-- 创建用户命令
vim.api.nvim_create_user_command("FastMode", function()
  M.enable()
end, { desc = "Enable Fast Mode (minimal plugins)" })

vim.api.nvim_create_user_command("FullMode", function()
  M.disable()
end, { desc = "Enable Full Mode (all plugins)" })

vim.api.nvim_create_user_command("ToggleMode", function()
  M.toggle()
end, { desc = "Toggle between Fast and Full mode" })

vim.api.nvim_create_user_command("ModeStatus", function()
  M.status()
end, { desc = "Show current mode status" })

-- 兼容旧版 TurboMode 命令
vim.api.nvim_create_user_command("TurboMode", function()
  M.enable()
end, { desc = "Enable Turbo Mode for maximum speed" })

vim.api.nvim_create_user_command("TurboModeOff", function()
  M.disable()
end, { desc = "Disable Turbo Mode" })

vim.api.nvim_create_user_command("TurboStatus", function()
  M.status()
end, { desc = "Check Turbo Mode status" })

return M
