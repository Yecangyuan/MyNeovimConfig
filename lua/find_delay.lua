-- 🔍 查找 hjkl 延迟的根本原因
-- 运行 :luafile lua/find_delay.lua

local M = {}

M.find_delay = function()
  print("=" .. string.rep("=", 60))
  print("🔍 查找 hjkl 延迟的根本原因")
  print("=" .. string.rep("=", 60))

  -- 1. 检查 timeoutlen（最关键）
  print("\n⌨️  1. 按键超时设置（最关键）")
  print(string.format("   timeout: %s", vim.o.timeout and "启用" or "禁用"))
  print(string.format("   ttimeout: %s", vim.o.ttimeout and "启用" or "禁用"))
  print(string.format("   timeoutlen: %d ms ← 映射等待时间", vim.o.timeoutlen))
  print(string.format("   ttimeoutlen: %d ms ← 键码等待时间", vim.o.ttimeoutlen))

  if vim.o.timeoutlen > 200 then
    print("   ⚠️  timeoutlen 过大！建议设为 100 或 0")
  end
  if vim.o.ttimeoutlen > 10 then
    print("   ⚠️  ttimeoutlen 过大！建议设为 0 或 1")
  end

  -- 2. 检查是否有映射以 h j k l 开头
  print("\n🗺️  2. 检查可能延迟 hjkl 的映射")

  local suspicious_maps = {}
  local modes = { "n", "v", "x", "o" }

  for _, mode in ipairs(modes) do
    local maps = vim.api.nvim_get_keymap(mode)
    for _, map in ipairs(maps) do
      local lhs = map.lhs or ""
      -- 检查以 h j k l 开头的映射
      if lhs:match("^h") or lhs:match("^j") or lhs:match("^k") or lhs:match("^l") then
        if lhs ~= "h" and lhs ~= "j" and lhs ~= "k" and lhs ~= "l"
           and lhs ~= "<leader>h" and lhs ~= "<leader>j"
           and lhs ~= "<leader>k" and lhs ~= "<leader>l" then
          table.insert(suspicious_maps, {
            mode = mode,
            lhs = lhs,
            rhs = map.rhs or "<function>",
            desc = map.desc or ""
          })
        end
      end
    end
  end

  if #suspicious_maps > 0 then
    print(string.format("   ⚠️  发现 %d 个可能影响 hjkl 的映射:", #suspicious_maps))
    for _, map in ipairs(suspicious_maps) do
      print(string.format("      %s %s → %s", map.mode, map.lhs, map.desc ~= "" and map.desc or map.rhs))
    end
    print("   这些映射会让 Vim 等待下一个键，导致 hjkl 延迟")
  else
    print("   ✅ 没有发现影响 hjkl 的映射")
  end

  -- 3. 检查自动命令
  print("\n🔔 3. 检查 CursorMoved 自动命令（每次移动光标都触发）")

  local cursor_moved_cmds = vim.api.nvim_get_autocmds({ event = "CursorMoved" })
  local cursor_moved_i_cmds = vim.api.nvim_get_autocmds({ event = "CursorMovedI" })

  local total = #cursor_moved_cmds + #cursor_moved_i_cmds
  print(string.format("   CursorMoved: %d 个", #cursor_moved_cmds))
  print(string.format("   CursorMovedI: %d 个", #cursor_moved_i_cmds))

  if total > 5 then
    print(string.format("   ⚠️  自动命令过多！这会导致每次 hjkl 都执行 %d 个回调", total))
  elseif total > 0 then
    print(string.format("   ℹ️  有 %d 个自动命令", total))
  else
    print("   ✅ 没有 CursorMoved 自动命令")
  end

  -- 4. 检查 Treesitter
  print("\n🌳 4. Treesitter 状态")
  local bufnr = vim.api.nvim_get_current_buf()
  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if ok then
    local has_parser = parsers.has_parser()
    print(string.format("   当前文件解析器: %s", has_parser and "已加载" or "未加载"))

    if has_parser then
      print("   提示: 可以临时禁用测试 :TSBufDisable highlight")
    end
  end

  -- 5. 检查 LSP
  print("\n🔌 5. LSP 状态")
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #clients > 0 then
    print(string.format("   已连接 %d 个 LSP 服务器:", #clients))
    for _, client in ipairs(clients) do
      print(string.format("      - %s", client.name))
    end
    print("   提示: 可以临时停止测试 :LspStop")
  else
    print("   无 LSP 连接")
  end

  -- 6. 检查当前文件大小
  print("\n📄 6. 当前文件")
  local lines = vim.api.nvim_buf_line_count(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  print(string.format("   行数: %d", lines))
  if lines > 1000 then
    print("   ⚠️  大文件！建议禁用语法高亮 :set syntax=off")
  end

  -- 7. 检查视觉设置
  print("\n👁️  7. 视觉设置")
  print(string.format("   cursorline: %s", vim.o.cursorline and "启用" or "禁用"))
  print(string.format("   relativenumber: %s", vim.o.relativenumber and "启用" or "禁用"))
  print(string.format("   lazyredraw: %s", vim.o.lazyredraw and "启用" or "禁用"))

  if vim.o.cursorline then
    print("   ⚠️  cursorline 会导致每次移动都重绘整行")
  end
  if vim.o.relativenumber then
    print("   ⚠️  relativenumber 会导致每次移动都重新计算行号")
  end

  -- 8. 终端类型
  print("\n💻 8. 终端信息")
  print(string.format("   TERM: %s", vim.env.TERM or "未设置"))
  print(string.format("   tmux: %s", vim.env.TMUX and "是" or "否"))

  if vim.env.TERM and vim.env.TERM:match("256color") == nil then
    print("   ⚠️  TERM 可能未优化，建议设为 xterm-256color 或 screen-256color")
  end

  -- 建议
  print("\n" .. string.rep("=", 62))
  print("💡 快速测试建议:")
  print("")
  print("1. 立即禁用所有可能的功能测试：")
  print("   :luafile lua/minimal_test.lua")
  print("")
  print("2. 如果变快了，逐一排查：")
  print("   - 检查映射冲突（上面第 2 项）")
  print("   - 禁用 cursorline :set nocursorline")
  print("   - 禁用 relativenumber :set norelativenumber")
  print("   - 停止 LSP :LspStop")
  print("   - 禁用 Treesitter :TSBufDisable highlight")
  print("")
  print("3. 如果还是慢，可能是终端问题：")
  print("   在终端运行 'cat' 然后按 hjkl 测试")
  print("")
  print("4. 最简测试：")
  print("   nvim --clean")
  print("   如果 --clean 很快，说明是配置问题")
end

M.find_delay()

return M
