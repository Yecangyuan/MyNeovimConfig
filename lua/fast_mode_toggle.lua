-- 极速模式切换工具
-- 提供命令快速切换模式

local M = {}

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
  vim.g.turbo_mode = true

  -- 立即应用一些设置
  vim.opt.cursorline = false
  vim.opt.relativenumber = false
  vim.opt.updatetime = 100
  vim.opt.timeoutlen = 150

  -- 禁用一些功能
  vim.cmd("TSBufDisable highlight")

  print("✓ 已应用极速设置")
  print("⚠️  请运行 :Lazy sync 并重启 Neovim 以完全生效")
end

-- 禁用极速模式（恢复完整功能）
M.disable = function()
  print("正在恢复到完整功能模式...")
  vim.g.turbo_mode = false

  -- 恢复设置
  vim.opt.cursorline = true
  vim.opt.relativenumber = true
  vim.opt.updatetime = 250
  vim.opt.timeoutlen = 200

  vim.cmd("TSBufEnable highlight")

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

return M
