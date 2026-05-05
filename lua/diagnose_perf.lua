-- 性能诊断脚本
-- 运行 :luafile lua/diagnose_perf.lua 查看性能报告

local M = {}

M.run = function()
  print("=" .. string.rep("=", 50))
  print("Neovim 性能诊断报告")
  print("=" .. string.rep("=", 50))

  -- 1. 检查可能导致延迟的插件
  print("\n📦 可能导致延迟的插件:")

  local suspect_plugins = {
    "smoothcursor",
    "indentscope",
    "illuminate",
    "cursorword",
    "hlslens",
    "treesitter",
    "indent-blankline",
    "matchparen",
    "noice",
  }

  for _, name in ipairs(suspect_plugins) do
    local ok, plugin = pcall(require, name)
    if ok then
      print("  ⚠️  " .. name .. " - 已加载，可能影响性能")
    end
  end

  -- 2. 检查当前选项
  print("\n⚙️  关键性能选项:")
  print("  updatetime: " .. vim.o.updatetime .. "ms (CursorHold 触发间隔)")
  print("  timeoutlen: " .. vim.o.timeoutlen .. "ms (按键序列等待)")
  print("  ttimeoutlen: " .. vim.o.ttimeoutlen .. "ms (键码序列等待)")
  print("  lazyredraw: " .. tostring(vim.o.lazyredraw) .. " (延迟重绘)")
  print("  cursorline: " .. tostring(vim.o.cursorline) .. " (光标行高亮)")
  print("  relativenumber: " .. tostring(vim.o.relativenumber) .. " (相对行号)")

  -- 3. 检查文件大小
  print("\n📄 当前文件信息:")
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_line_count(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local ok, stats = pcall(vim.loop.fs_stat, name)
  local size = ok and stats and stats.size or 0

  print("  文件名: " .. (name ~= "" and name or "[未命名]"))
  print("  行数: " .. lines)
  print("  大小: " .. string.format("%.2f", size / 1024) .. " KB")

  if lines > 1000 or size > 100 * 1024 then
    print("  ⚠️  大文件检测：建议禁用 Treesitter 和 LSP 以提高性能")
  end

  -- 4. 检查自动命令
  print("\n🔔 CursorHold 自动命令数量:")
  local autocmds = vim.api.nvim_get_autocmds({ event = "CursorHold" })
  print("  数量: " .. #autocmds)
  if #autocmds > 5 then
    print("  ⚠️  自动命令过多，可能导致延迟")
  end

  -- 5. 检查 LSP 客户端
  print("\n🔌 活动的 LSP 客户端:")
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    print("  - " .. client.name)
  end
  if #clients == 0 then
    print("  无")
  end

  -- 6. 检查 Treesitter
  print("\n🌳 Treesitter 状态:")
  local ok, ts = pcall(require, "nvim-treesitter.parsers")
  if ok then
    local parser = ts.get_parser(bufnr)
    if parser then
      print("  解析器: " .. parser:lang())
      print("  状态: 已激活")
      if lines > 1000 then
        print("  ⚠️  大文件建议禁用 Treesitter")
      end
    else
      print("  状态: 未激活")
    end
  else
    print("  无法检测 Treesitter 状态")
  end

  -- 7. 检查 highlight 组
  print("\n🎨 搜索高亮状态:")
  print("  hlsearch: " .. tostring(vim.o.hlsearch))
  if vim.o.hlsearch then
    print("  ⚠️  hlsearch 开启，搜索后记得按 :noh 清除高亮")
  end

  print("\n" .. string.rep("=", 52))
  print("诊断完成")
  print(string.rep("=", 52))
  print("\n💡 建议:")
  print("  1. 如果在大文件中感到延迟，尝试 :TSBufDisable highlight")
  print("  2. 禁用 smoothcursor.nvim 后重启 Neovim")
  print("  3. 检查是否有其他终端软件拦截了按键")
  print("  4. 尝试 :noh 清除搜索高亮")
end

M.run()

return M
