local options = require "nvchad.options"

-- =============================================
-- 🚀 原生 Vim 性能优化 - 解决 hjkl 延迟
-- =============================================

local opt = vim.opt
local o = vim.o

-- ⌨️  关键：按键超时设置（解决 hjkl 延迟的核心）
o.timeout = true           -- 启用映射超时
o.ttimeout = true          -- 启用键码超时
o.timeoutlen = 100         -- 映射序列等待 100ms（NvChad 默认 100）
o.ttimeoutlen = 0          -- ⚡ 关键：键码序列无等待！

-- 👁️ 视觉优化 - 禁用所有可能导致重绘的功能
o.cursorline = false       -- ❌ 禁用光标行（大大减少重绘）
o.cursorlineopt = "number" -- 即使启用也只高亮行号
opt.relativenumber = false -- ❌ 禁用相对行号（实时计算行号差）
o.number = true            -- 只保留绝对行号

-- 🎨 语法高亮优化
o.synmaxcol = 200          -- 超过 200 列不再语法高亮
o.redrawtime = 1000        -- 语法高亮超时
o.maxmempattern = 1000     -- 限制模式匹配内存

-- 🔍 搜索优化
o.hlsearch = false         -- 禁用搜索高亮（避免搜索后卡顿）

-- 📁 文件优化
opt.swapfile = false       -- 禁用交换文件
opt.backup = false
opt.writebackup = false

-- 🖱️ 输入优化
opt.mouse = ""             -- 禁用鼠标（减少事件处理）

-- 🔔 提示优化
o.showcmd = false          -- 禁用右下角命令显示

-- 📐 折叠优化
o.foldenable = false       -- 默认禁用折叠

-- =============================================
-- ⚡ 大文件自动优化
-- =============================================
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*",
  callback = function()
    local lines = vim.api.nvim_buf_line_count(0)
    if lines > 500 then
      vim.opt_local.cursorline = false
      vim.opt_local.relativenumber = false
      vim.opt_local.foldenable = false
    end
    if lines > 3000 then
      vim.cmd("syntax off")  -- 超大文件完全禁用语法高亮
      print("Large file detected: syntax off for speed")
    end
  end,
})
