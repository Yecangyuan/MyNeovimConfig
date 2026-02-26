-- 🏎️ Turbo Mode - 一键极速模式切换
-- 使用方法：
--   :luafile lua/turbo_mode.lua     -- 临时进入极速模式
--   或运行 :TurboMode 命令

local M = {}

-- 保存原始设置
local original_settings = {}

M.enable = function()
  print("🏎️  正在启用 Turbo Mode...")

  -- 保存当前设置
  original_settings.cursorline = vim.o.cursorline
  original_settings.cursorcolumn = vim.o.cursorcolumn
  original_settings.relativenumber = vim.o.relativenumber
  original_settings.number = vim.o.number
  original_settings.foldenable = vim.o.foldenable
  original_settings.mouse = vim.o.mouse
  original_settings.updatetime = vim.o.updatetime
  original_settings.timeoutlen = vim.o.timeoutlen

  -- 极速模式设置
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
  vim.o.synmaxcol = 200

  -- 禁用 Treesitter 高亮（如果已加载）
  local ok, _ = pcall(require, "nvim-treesitter")
  if ok then
    vim.cmd("TSBufDisable highlight")
    vim.cmd("TSBufDisable indent")
    print("  ✓ Treesitter 高亮已禁用")
  end

  -- 停止 LSP（如果需要最大速度）
  -- vim.cmd("LspStop")

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

  print("🏁 Turbo Mode 已启用！光标移动应该已经飞快了")
  print("💡 提示：运行 :lua require'turbo_mode'.disable() 恢复")
end

M.disable = function()
  print("正在恢复原始设置...")

  -- 恢复设置
  for key, value in pairs(original_settings) do
    vim.o[key] = value
  end

  -- 重新启用 Treesitter
  vim.cmd("TSBufEnable highlight")
  vim.cmd("TSBufEnable indent")

  print("已恢复原始设置")
end

M.status = function()
  print("🏎️  Turbo Mode 状态：")
  print("  cursorline: " .. tostring(vim.o.cursorline))
  print("  relativenumber: " .. tostring(vim.o.relativenumber))
  print("  updatetime: " .. vim.o.updatetime)
  print("  timeoutlen: " .. vim.o.timeoutlen)
end

-- 创建命令
vim.api.nvim_create_user_command("TurboMode", function()
  M.enable()
end, { desc = "Enable Turbo Mode for maximum speed" })

vim.api.nvim_create_user_command("TurboModeOff", function()
  M.disable()
end, { desc = "Disable Turbo Mode" })

vim.api.nvim_create_user_command("TurboStatus", function()
  M.status()
end, { desc = "Check Turbo Mode status" })

-- 如果直接运行此文件，启用 Turbo Mode
M.enable()

return M
