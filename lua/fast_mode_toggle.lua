-- 极速模式切换工具
-- 提供命令快速切换模式

local mode = require "core.mode"

local M = {}
local original_settings = {}

M.is_fast_mode = mode.is_turbo

M.toggle = function()
  if M.is_fast_mode() then
    M.disable()
  else
    M.enable()
  end
end

local function disable_plugins()
  local ok_ts = pcall(require, "nvim-treesitter")
  if ok_ts then
    vim.cmd "TSBufDisable highlight"
    vim.cmd "TSBufDisable indent"
    print "  ✓ Treesitter 高亮已禁用"
  end

  local ok_ibl, ibl = pcall(require, "ibl")
  if ok_ibl then
    ibl.setup_buffer(0, { enabled = false })
    print "  ✓ 缩进线已禁用"
  end

  local ok_gs, gitsigns = pcall(require, "gitsigns")
  if ok_gs then
    gitsigns.detach()
    print "  ✓ Git 标记已禁用"
  end
end

local function enable_plugins()
  local ok_ts = pcall(require, "nvim-treesitter")
  if ok_ts then
    vim.cmd "TSBufEnable highlight"
    vim.cmd "TSBufEnable indent"
    print "  ✓ Treesitter 高亮已启用"
  end
end

M.enable = function()
  print "🏎️  正在切换到极速模式..."

  local current = mode.current()
  for key, _ in pairs(mode.options[current]) do
    original_settings[key] = vim.o[key]
  end

  vim.g.turbo_mode = true
  mode.apply "turbo"
  disable_plugins()

  print "✓ 已应用极速设置"
  print "⚠️  部分插件需要重启 Neovim 才能完全生效"
end

M.disable = function()
  print "正在恢复到完整功能模式..."

  vim.g.turbo_mode = false
  for key, value in pairs(original_settings) do
    vim.opt[key] = value
  end
  original_settings = {}
  enable_plugins()

  print "✓ 已恢复设置"
  print "⚠️  部分插件需要重启 Neovim 才能完全生效"
end

M.status = function()
  local mode_str = M.is_fast_mode() and "🏎️  极速模式" or "🐌 完整功能模式"
  print("当前模式: " .. mode_str)
  print ""
  print "当前设置:"
  print("  cursorline: " .. tostring(vim.o.cursorline))
  print("  relativenumber: " .. tostring(vim.o.relativenumber))
  print("  updatetime: " .. vim.o.updatetime)
  print("  timeoutlen: " .. vim.o.timeoutlen)
end

vim.api.nvim_create_user_command("FastMode", M.enable, { desc = "Enable Fast Mode (minimal plugins)" })
vim.api.nvim_create_user_command("FullMode", M.disable, { desc = "Enable Full Mode (all plugins)" })
vim.api.nvim_create_user_command("ToggleMode", M.toggle, { desc = "Toggle between Fast and Full mode" })
vim.api.nvim_create_user_command("ModeStatus", M.status, { desc = "Show current mode status" })

-- 兼容旧版 TurboMode 命令
vim.api.nvim_create_user_command("TurboMode", M.enable, { desc = "Enable Turbo Mode for maximum speed" })
vim.api.nvim_create_user_command("TurboModeOff", M.disable, { desc = "Disable Turbo Mode" })
vim.api.nvim_create_user_command("TurboStatus", M.status, { desc = "Check Turbo Mode status" })

return M
