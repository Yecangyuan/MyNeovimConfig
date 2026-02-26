-- 🚀 原生 Vim 极速配置 - 解决 hjkl 延迟问题
-- 复制到 options.lua 或运行 :luafile lua/native_speed.lua

local opt = vim.opt
local g = vim.g
local o = vim.o

-- =============================================
-- ⌨️  按键延迟优化（核心）
-- =============================================

-- 方案 A: 完全禁用超时（最快，但多字符映射如 gj 可能失效）
-- o.timeout = false

-- 方案 B: 极短超时（推荐，平衡速度和功能）
o.timeout = true           -- 启用映射超时
o.ttimeout = true          -- 启用键码超时
o.timeoutlen = 100         -- 映射序列等待 100ms
o.ttimeoutlen = 0          -- 键码序列无等待（关键！）

-- 方案 C: 如果你用 tmux 或某些终端，可能需要：
-- o.ttimeoutlen = 10       -- 极短的键码超时

-- =============================================
-- 👁️ 视觉优化（减少重绘）
-- =============================================

opt.cursorline = false       -- 禁用光标行（最大重绘来源）
opt.cursorcolumn = false     -- 禁用光标列
opt.relativenumber = false   -- 禁用相对行号（实时计算差值）
opt.number = true            -- 只保留绝对行号
opt.signcolumn = "yes"       -- 固定侧边栏宽度，避免跳动
opt.colorcolumn = ""         -- 禁用颜色标记列

-- 滚动优化
opt.scrolloff = 0            -- 最小滚动偏移
opt.sidescrolloff = 0
opt.smoothscroll = false     -- 禁用平滑滚动（Neovim 0.10+）

-- =============================================
-- 🎨 语法高亮优化
-- =============================================

opt.synmaxcol = 200          -- 超过 200 列不再语法高亮
opt.redrawtime = 1000        -- 语法高亮超时 1 秒
opt.maxmempattern = 1000     -- 限制模式匹配内存

-- 限制语法同步范围（减少计算）
vim.cmd([[
  augroup SyntaxOptimize
    autocmd!
    autocmd BufWinEnter * syntax sync minlines=100 maxlines=200
  augroup END
]])

-- =============================================
-- 🔍 搜索优化
-- =============================================

opt.hlsearch = false         -- 禁用搜索高亮（避免搜索后卡顿）
opt.incsearch = true         -- 保留增量搜索（有用）
opt.ignorecase = true
opt.smartcase = true

-- 快速清除搜索高亮的映射
vim.keymap.set('n', '<Esc>', '<Cmd>nohlsearch<CR><Esc>', { silent = true })

-- =============================================
-- 📁 文件优化
-- =============================================

opt.swapfile = false         -- 禁用交换文件（减少 IO）
opt.backup = false           -- 禁用备份
opt.writebackup = false      -- 禁用写入备份
opt.undofile = false         -- 禁用撤销文件（如需要可改为 true）

-- =============================================
-- 🖱️ 输入优化
-- =============================================

opt.mouse = ""               -- 禁用鼠标（减少事件处理）
opt.ttyfast = true           -- 快速终端连接

-- =============================================
-- 🔔 提示优化
-- =============================================

opt.visualbell = false       -- 禁用视觉响铃
opt.errorbells = false       -- 禁用错误响铃
opt.showcmd = false          -- 禁用右下角命令显示（减少重绘）
opt.showmode = false         -- 禁用模式显示（状态栏插件会处理）

-- =============================================
-- 📐 折叠优化
-- =============================================

opt.foldenable = false       -- 默认禁用折叠
opt.foldmethod = "manual"    -- 手动折叠（最快）
-- opt.foldmethod = "indent"  -- 如果需要自动折叠，用这个比 syntax 快

-- =============================================
-- 🚀 启动优化
-- =============================================

-- 禁用内置插件
g.loaded_matchparen = 1      -- 禁用括号匹配（实时计算）
g.loaded_matchit = 1         -- 禁用 matchit
g.loaded_2html_plugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_gzip = 1
g.loaded_logipat = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1
g.loaded_rrhelper = 1
g.loaded_spellfile_plugin = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_tutor = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1

-- =============================================
-- ⚡ 自动命令优化（关键！）
-- =============================================

-- 减少 CursorHold 触发频率（影响很多插件）
opt.updatetime = 100         -- 100ms 更新（默认 4000ms，但 NvChad 设为 250）

-- 大文件自动优化
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*",
  callback = function()
    local lines = vim.api.nvim_buf_line_count(0)
    if lines > 1000 then
      -- 大文件禁用重型功能
      vim.opt_local.cursorline = false
      vim.opt_local.relativenumber = false
      vim.opt_local.foldenable = false
      vim.opt_local.syntax = "off"  -- 完全禁用语法高亮
      print("Large file: syntax highlighting disabled for speed")
    end
  end,
})

-- =============================================
-- 🧪 调试函数
-- =============================================

-- 检查当前延迟相关设置
vim.api.nvim_create_user_command("CheckLatency", function()
  print("🚀 延迟相关设置检查：")
  print("")
  print("按键超时：")
  print(string.format("  timeout: %s", tostring(vim.o.timeout)))
  print(string.format("  ttimeout: %s", tostring(vim.o.ttimeout)))
  print(string.format("  timeoutlen: %d ms", vim.o.timeoutlen))
  print(string.format("  ttimeoutlen: %d ms", vim.o.ttimeoutlen))
  print("")
  print("视觉设置：")
  print(string.format("  cursorline: %s", tostring(vim.o.cursorline)))
  print(string.format("  relativenumber: %s", tostring(vim.o.relativenumber)))
  print(string.format("  lazyredraw: %s", tostring(vim.o.lazyredraw)))
  print("")
  print("更新频率：")
  print(string.format("  updatetime: %d ms", vim.o.updatetime))
  print("")
  print("💡 如果 timeoutlen > 0，尝试设为 0 或 50")
end, {})

print("🚀 原生极速配置已加载！")
print("运行 :CheckLatency 查看当前延迟设置")
