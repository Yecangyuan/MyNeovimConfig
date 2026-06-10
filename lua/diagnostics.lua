-- 性能诊断模块
-- 合并 perf_check.lua / find_delay.lua / diagnose_perf.lua
-- Usage: :Diagnostics [perf|delay|all]

local M = {}

local BIG_FILE_LINES = 1000
local BIG_FILE_SIZE = 100 * 1024

-- =============================================
-- 公共工具函数
-- =============================================
local function print_header(title)
  print("=" .. string.rep("=", 60))
  print(title)
  print("=" .. string.rep("=", 60))
end

local function print_section(title)
  print("\n" .. title)
end

local function format_opt(name, value)
  return string.format("  %-20s %s", name, value)
end

local function check_plugin(name, desc)
  local ok = package.loaded[name] ~= nil
  local status = ok and "✅ 已加载" or "❌ 未加载"
  print(string.format("  %-20s %s (%s)", name, status, desc or ""))
end

-- =============================================
-- 性能概览（原 perf_check.lua）
-- =============================================
M.check_perf = function()
  print_header("🚀 性能诊断概览")

  local is_turbo = vim.g.turbo_mode == true
  print_section("📊 当前模式: " .. (is_turbo and "🏎️ 极速模式" or "🐌 普通模式"))

  print_section("⚙️ 关键性能设置:")
  print(format_opt("cursorline:", tostring(vim.o.cursorline)))
  print(format_opt("relativenumber:", tostring(vim.o.relativenumber)))
  print(format_opt("updatetime:", vim.o.updatetime .. " ms"))
  print(format_opt("timeoutlen:", vim.o.timeoutlen .. " ms"))
  print(format_opt("ttimeoutlen:", vim.o.ttimeoutlen .. " ms"))
  print(format_opt("lazyredraw:", tostring(vim.o.lazyredraw)))
  print(format_opt("foldenable:", tostring(vim.o.foldenable)))

  print_section("📦 性能敏感插件状态:")
  check_plugin("gitsigns", "Git 标记（实时更新）")
  check_plugin("ibl", "缩进线（重绘）")
  check_plugin("indent_blankline", "缩进线（重绘）")
  check_plugin("smoothcursor", "光标动画")
  check_plugin("mini.indentscope", "缩进范围（实时计算）")
  check_plugin("mini.cursorword", "单词高亮（重绘）")
  check_plugin("noice", "消息美化（拦截）")
  check_plugin("hlslens", "搜索高亮增强")
  check_plugin("windows", "窗口动画")
  check_plugin("trouble", "诊断列表")

  print_section("📄 当前文件:")
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_line_count(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local ok, stats = pcall(vim.uv.fs_stat, name)
  local size = ok and stats and stats.size or 0

  print(string.format("  文件名: %s", name ~= "" and name or "[未命名]"))
  print(string.format("  行数: %d", lines))
  print(string.format("  大小: %.2f KB", size / 1024))

  if lines > BIG_FILE_LINES or size > BIG_FILE_SIZE then
    print("  ⚠️  警告：大文件！建议禁用 Treesitter 和 LSP")
  end

  print_section("🔌 LSP 客户端:")
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #clients == 0 then
    print("  无")
  else
    for _, client in ipairs(clients) do
      print(string.format("  - %s", client.name))
    end
  end

  print_section("🌳 Treesitter:")
  local ok_ts, parsers = pcall(require, "nvim-treesitter.parsers")
  if ok_ts then
    local has_parser = parsers.has_parser and parsers.has_parser(vim.bo[bufnr].filetype) or false
    print(string.format("  解析器: %s", has_parser and "已激活" or "未激活"))
  else
    print("  无法检测状态")
  end

  print_section("💡 建议:")
  if not is_turbo then
    print("  1. 尝试极速模式: :FastMode")
  end
  if lines > BIG_FILE_LINES then
    print("  " .. (is_turbo and "1" or "2") .. ". 大文件建议禁用 Treesitter: :TSBufDisable highlight")
  end
  if vim.o.cursorline then
    print("  " .. (is_turbo and (lines > BIG_FILE_LINES and "2" or "1") or (lines > BIG_FILE_LINES and "3" or "2")) .. ". 禁用光标行: :set nocursorline")
  end
  if vim.o.relativenumber then
    print("  " .. (is_turbo and (lines > BIG_FILE_LINES and "3" or "2") or (lines > BIG_FILE_LINES and "4" or "3")) .. ". 禁用相对行号: :set norelativenumber")
  end

  print("\n" .. string.rep("=", 62))
end

-- =============================================
-- 延迟根因分析（原 find_delay.lua）
-- =============================================
M.find_delay = function()
  print_header("🔍 查找 hjkl 延迟的根本原因")

  print_section("⌨️ 1. 按键超时设置（最关键）")
  print(string.format("   timeout: %s", vim.o.timeout and "启用" or "禁用"))
  print(string.format("   ttimeout: %s", vim.o.ttimeout and "启用" or "禁用"))
  print(string.format("   timeoutlen: %d ms ← 映射等待时间", vim.o.timeoutlen))
  print(string.format("   ttimeoutlen: %d ms ← 键码等待时间", vim.o.ttimeoutlen))

  if vim.o.timeoutlen > 200 then
    print("   ⚠️ timeoutlen 过大！建议设为 100 或 0")
  end
  if vim.o.ttimeoutlen > 10 then
    print("   ⚠️ ttimeoutlen 过大！建议设为 0 或 1")
  end

  print_section("🗺️ 2. 检查可能延迟 hjkl 的映射")
  local suspicious_maps = {}
  local modes = { "n", "v", "x", "o" }
  for _, mode in ipairs(modes) do
    local maps = vim.api.nvim_get_keymap(mode)
    for _, map in ipairs(maps) do
      local lhs = map.lhs or ""
      if lhs:match("^[hjkl]") and lhs ~= "h" and lhs ~= "j" and lhs ~= "k" and lhs ~= "l"
         and not lhs:match("^<leader>") then
        table.insert(suspicious_maps, { mode = mode, lhs = lhs, desc = map.desc or (map.rhs or "<function>") })
      end
    end
  end

  if #suspicious_maps > 0 then
    print(string.format("   ⚠️ 发现 %d 个可能影响 hjkl 的映射:", #suspicious_maps))
    for _, map in ipairs(suspicious_maps) do
      print(string.format("      %s %s → %s", map.mode, map.lhs, map.desc))
    end
  else
    print("   ✅ 没有发现影响 hjkl 的映射")
  end

  print_section("🔔 3. CursorMoved 自动命令")
  local cursor_moved_cmds = vim.api.nvim_get_autocmds({ event = "CursorMoved" })
  local cursor_moved_i_cmds = vim.api.nvim_get_autocmds({ event = "CursorMovedI" })
  local total = #cursor_moved_cmds + #cursor_moved_i_cmds
  print(string.format("   CursorMoved: %d, CursorMovedI: %d", #cursor_moved_cmds, #cursor_moved_i_cmds))
  if total > 5 then
    print(string.format("   ⚠️ 自动命令过多（%d 个），每次移动都触发", total))
  end

  print_section("🌳 4. Treesitter 状态")
  local bufnr = vim.api.nvim_get_current_buf()
  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if ok then
    local has_parser = parsers.has_parser and parsers.has_parser(vim.bo[bufnr].filetype) or false
    print(string.format("   当前文件解析器: %s", has_parser and "已加载" or "未加载"))
  end

  print_section("🔌 5. LSP 状态")
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #clients > 0 then
    print(string.format("   已连接 %d 个 LSP 服务器:", #clients))
    for _, client in ipairs(clients) do
      print(string.format("      - %s", client.name))
    end
  else
    print("   无 LSP 连接")
  end

  print_section("📄 6. 当前文件")
  local lines = vim.api.nvim_buf_line_count(bufnr)
  print(string.format("   行数: %d", lines))
  if lines > BIG_FILE_LINES then
    print("   ⚠️ 大文件！建议禁用语法高亮 :set syntax=off")
  end

  print_section("👁️ 7. 视觉设置")
  print(string.format("   cursorline: %s", vim.o.cursorline and "启用" or "禁用"))
  print(string.format("   relativenumber: %s", vim.o.relativenumber and "启用" or "禁用"))
  if vim.o.cursorline then
    print("   ⚠️ cursorline 会导致每次移动都重绘整行")
  end
  if vim.o.relativenumber then
    print("   ⚠️ relativenumber 会导致每次移动都重新计算行号")
  end

  print_section("💻 8. 终端信息")
  print(string.format("   TERM: %s", vim.env.TERM or "未设置"))
  print(string.format("   tmux: %s", vim.env.TMUX and "是" or "否"))

  print("\n" .. string.rep("=", 62))
  print("💡 快速测试建议:")
  print("1. 最简测试: nvim --clean")
  print("2. 逐一排查: :set nocursorline, :set norelativenumber, :LspStop, :TSBufDisable highlight")
end

-- =============================================
-- 主入口
-- =============================================
M.run = function(mode)
  mode = mode or "all"
  if mode == "perf" then
    M.check_perf()
  elseif mode == "delay" then
    M.find_delay()
  else
    M.check_perf()
    M.find_delay()
  end
end

-- 注册命令
vim.api.nvim_create_user_command("Diagnostics", function(opts)
  M.run(opts.args)
end, {
  nargs = "?",
  complete = function()
    return { "perf", "delay", "all" }
  end,
  desc = "Run performance diagnostics (perf|delay|all)",
})

return M
