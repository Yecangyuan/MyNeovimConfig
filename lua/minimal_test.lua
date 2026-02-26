-- 最小化测试配置 - 排除所有可能的延迟来源
-- 运行 :luafile lua/minimal_test.lua 测试

print("🧪 正在应用最小化测试配置...")

-- =============================================
-- 1. 按键超时设置（最关键）
-- =============================================

-- 完全禁用映射超时 - 按键立即生效
vim.o.timeout = false        -- 禁用映射超时等待
vim.o.ttimeout = true        -- 启用键码超时
vim.o.timeoutlen = 0         -- 映射超时时间为 0
vim.o.ttimeoutlen = 0        -- 键码超时时间为 0

-- =============================================
-- 2. 禁用所有可能的重绘延迟
-- =============================================

vim.o.lazyredraw = false     -- 禁用延迟重绘
vim.o.redrawtime = 100       -- 语法高亮重绘超时
vim.o.maxmempattern = 100    -- 限制模式匹配内存

-- =============================================
-- 3. 禁用所有视觉特效
-- =============================================

vim.o.cursorline = false
vim.o.cursorcolumn = false
vim.o.relativenumber = false
vim.o.number = true
vim.o.signcolumn = "no"      -- 禁用侧边栏（减少重绘）
vim.o.foldenable = false
vim.o.list = false           -- 禁用特殊字符显示

-- =============================================
-- 4. 禁用搜索相关（可能拦截输入）
-- =============================================

vim.o.hlsearch = false       -- 禁用搜索高亮
vim.o.incsearch = false      -- 禁用增量搜索
vim.o.ignorecase = false     -- 禁用大小写忽略（减少计算）
vim.o.smartcase = false

-- =============================================
-- 5. 语法高亮最小化
-- =============================================

vim.o.synmaxcol = 120        -- 超过 120 列不语法高亮
vim.cmd("syntax sync minlines=50")  -- 限制语法同步范围
vim.cmd("syntax sync maxlines=100")

-- =============================================
-- 6. 禁用所有自动命令（可能拦截 CursorMoved）
-- =============================================

-- 清除所有自动命令
vim.cmd("autocmd!")

-- =============================================
-- 7. 禁用内置插件
-- =============================================

vim.g.loaded_matchparen = 1
vim.g.loaded_matchit = 1

-- =============================================
-- 8. 终端优化
-- =============================================

-- 设置快速终端
vim.o.ttyfast = true

-- 禁用鼠标（减少事件）
vim.o.mouse = ""

-- 禁用响铃
vim.o.visualbell = false
vim.o.errorbells = false

print("✅ 最小化配置已应用")
print("")
print("当前关键设置：")
print("  timeout: " .. tostring(vim.o.timeout) .. " (false = 无等待)")
print("  timeoutlen: " .. vim.o.timeoutlen .. " ms")
print("  ttimeoutlen: " .. vim.o.ttimeoutlen .. " ms")
print("  lazyredraw: " .. tostring(vim.o.lazyredraw))
print("")
print("🎯 现在测试 hjkl 移动，如果还有延迟，那就是终端或 Neovim 底层问题")
print("💡 如果变快了，说明是之前的 autocmd 或选项导致的")
