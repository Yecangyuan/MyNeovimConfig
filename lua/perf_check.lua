-- 性能检查脚本
-- 运行 :luafile lua/perf_check.lua

local M = {}

M.check = function()
  print("=" .. string.rep("=", 60))
  print("🚀 极速模式性能检查")
  print("=" .. string.rep("=", 60))

  -- 检查当前模式
  local is_turbo = vim.g.turbo_mode == true
  print("\n📊 当前模式: " .. (is_turbo and "🏎️  极速模式" or "🐌 普通模式"))

  -- 检查关键设置
  print("\n⚙️  关键性能设置:")
  print(string.format("  %-20s %s", "cursorline:", tostring(vim.o.cursorline)))
  print(string.format("  %-20s %s", "relativenumber:", tostring(vim.o.relativenumber)))
  print(string.format("  %-20s %d ms", "updatetime:", vim.o.updatetime))
  print(string.format("  %-20s %d ms", "timeoutlen:", vim.o.timeoutlen))
  print(string.format("  %-20s %d ms", "ttimeoutlen:", vim.o.ttimeoutlen))
  print(string.format("  %-20s %s", "lazyredraw:", tostring(vim.o.lazyredraw)))
  print(string.format("  %-20s %s", "foldenable:", tostring(vim.o.foldenable)))

  -- 检查插件加载状态
  print("\n📦 性能敏感插件状态:")

  local plugins = {
    { name = "gitsigns", desc = "Git 标记（实时更新）" },
    { name = "ibl", desc = "缩进线（重绘）" },
    { name = "indent_blankline", desc = "缩进线（重绘）" },
    { name = "smoothcursor", desc = "光标动画" },
    { name = "mini.indentscope", desc = "缩进范围（实时计算）" },
    { name = "mini.cursorword", desc = "单词高亮（重绘）" },
    { name = "noice", desc = "消息美化（拦截）" },
    { name = "hlslens", desc = "搜索高亮增强" },
    { name = "windows", desc = "窗口动画" },
    { name = "trouble", desc = "诊断列表" },
  }

  for _, p in ipairs(plugins) do
    local ok = package.loaded[p.name] ~= nil
    local status = ok and "✅ 已加载" or "❌ 未加载"
    print(string.format("  %-20s %s (%s)", p.name, status, p.desc))
  end

  -- 检查当前文件
  print("\n📄 当前文件:")
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_line_count(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local ok, stats = pcall(vim.loop.fs_stat, name)
  local size = ok and stats and stats.size or 0

  print(string.format("  文件名: %s", name ~= "" and name or "[未命名]"))
  print(string.format("  行数: %d", lines))
  print(string.format("  大小: %.2f KB", size / 1024))

  if lines > 1000 or size > 100 * 1024 then
    print("  ⚠️  警告：大文件！建议使用极速模式")
  end

  -- 检查 LSP
  print("\n🔌 LSP 客户端:")
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  if #clients == 0 then
    print("  无")
  else
    for _, client in ipairs(clients) do
      print(string.format("  - %s", client.name))
    end
  end

  -- 检查 Treesitter
  print("\n🌳 Treesitter:")
  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if ok then
    local has_parser = parsers.has_parser()
    print(string.format("  解析器: %s", has_parser and "已激活" or "未激活"))

    -- 检查是否启用了高亮
    local hl_ok, hl_module = pcall(require, "nvim-treesitter.highlight")
    if hl_ok then
      print(string.format("  高亮: 已启用（可通过 :TSBufDisable highlight 禁用）"))
    end
  else
    print("  无法检测状态")
  end

  -- 提供建议
  print("\n💡 建议:")

  if not is_turbo then
    print("  1. 尝试极速模式: :FastMode")
    print("  2. 然后重启 Neovim 查看效果")
  end

  if lines > 500 then
    print("  " .. (is_turbo and "1" or "3") .. ". 当前文件较大，建议禁用 Treesitter 高亮:")
    print("     :TSBufDisable highlight")
  end

  if vim.o.cursorline then
    print("  " .. (is_turbo and (lines > 500 and "2" or "1") or (lines > 500 and "4" or "3")) .. ". 禁用光标行可能提升速度:")
    print("     :set nocursorline")
  end

  if vim.o.relativenumber then
    print("  " .. (is_turbo and (lines > 500 and "3" or "2") or (lines > 500 and "5" or "4")) .. ". 禁用相对行号可能提升速度:")
    print("     :set norelativenumber")
  end

  print("\n" .. string.rep("=", 62))
end

M.check()

return M
