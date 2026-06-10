local options = require "nvchad.options"

-- =============================================
-- 🚀 原生 Vim 性能优化 - 解决 hjkl 延迟
-- =============================================

local o = vim.o

-- ⌨️  关键：按键超时设置（解决 hjkl 延迟的核心）
-- 注意：基础 timeoutlen/updatetime 由 core/bootstrap.lua 统一设置
o.timeout = true
o.ttimeout = true
-- 继承 bootstrap 已设置的值，避免重复定义导致冲突
o.timeoutlen = vim.o.timeoutlen
o.ttimeoutlen = vim.o.ttimeoutlen

-- 👁️ 视觉优化
cursorlineopt = "number" -- 即使启用 cursorline 也只高亮行号
o.number = true

-- 🎨 语法高亮优化
o.synmaxcol = 128          -- 超过 128 列不再语法高亮
o.redrawtime = 500         -- 语法高亮超时
o.maxmempattern = 1000     -- 限制模式匹配内存
o.regexpengine = 0         -- 自动选择最快正则引擎

-- 🔍 搜索优化
o.hlsearch = false         -- 禁用搜索高亮（避免搜索后卡顿）

-- 📁 文件优化
o.swapfile = false
o.backup = false
o.writebackup = false

-- 🖱️ 输入优化
o.mouse = ""               -- 禁用鼠标（减少事件处理）

-- 🔔 提示优化
o.showcmd = false          -- 禁用右下角命令显示

-- 📐 折叠优化
o.foldenable = false       -- 默认禁用折叠

-- =============================================
-- 🚀 大文件自动优化系统（核心性能优化）
-- =============================================
-- hjkl 卡顿的主要原因：
--   1. mini.cursorword 每次光标移动都在全 buffer 搜索高亮
--   2. mini.indentscope 每次光标移动都计算缩进范围
--   3. indent-blankline 滚动时重新计算可见行缩进层级
--   4. colorizer 扫描每行颜色代码
--   5. gitsigns 大文件 sign column 持续更新
-- 本系统自动检测大文件并禁用这些功能

local big_file_group = vim.api.nvim_create_augroup("BigFilePerf", { clear = true })

-- 阶段1: 读取前按文件大小预检测（buffer 解析前）
vim.api.nvim_create_autocmd("BufReadPre", {
  group = big_file_group,
  callback = function(args)
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > 100 * 1024 then -- 100KB
      vim.b[args.buf].big_file = true
    end
  end,
})

-- 阶段2: 读取后按行数检测 + 全面优化
vim.api.nvim_create_autocmd("BufReadPost", {
  group = big_file_group,
  callback = function(args)
    local buf = args.buf
    local lines = vim.api.nvim_buf_line_count(buf)

    if not vim.b[buf].big_file and lines <= 1000 then
      return
    end

    vim.b[buf].big_file = true

    -- ── 禁用昂贵的 buffer 本地选项 ──
    vim.opt_local.cursorline = false
    vim.opt_local.cursorcolumn = false
    vim.opt_local.relativenumber = false
    vim.opt_local.foldenable = false
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.spell = false
    vim.opt_local.undolevels = 100
    vim.opt_local.synmaxcol = 80

    -- ── 禁用 mini 模块（hjkl 卡顿的主因）──
    vim.b[buf].minicursorword_disable = true
    vim.b[buf].miniindentscope_disable = true

    -- ── 延迟禁用其他插件（等插件附加后再禁用）──
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(buf) then return end
      pcall(function() require("ibl").setup_buffer(buf, { enabled = false }) end)
      pcall(function() require("colorizer").detach_from_buffer(buf) end)
    end)

    -- ── 超大文件（3000+行）：禁用更多功能 ──
    if lines > 3000 then
      vim.bo[buf].syntax = ""
      vim.opt_local.signcolumn = "yes:1" -- 固定宽度，避免重算
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(buf) then return end
        pcall(function() require("gitsigns").detach() end)
        -- 兼容不同 Neovim 版本禁用 diagnostics
        local ok_diag = pcall(vim.diagnostic.enable, false, { bufnr = buf })
        if not ok_diag then
          pcall(vim.diagnostic.disable, buf)
        end
      end)
    end
  end,
})

-- 阶段3: LSP 附加时优化大文件的 LSP 行为
vim.api.nvim_create_autocmd("LspAttach", {
  group = big_file_group,
  callback = function(args)
    if not vim.b[args.buf].big_file then return end
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    -- 禁用 documentHighlight（光标悬停高亮所有引用）
    client.server_capabilities.documentHighlightProvider = false
    -- 禁用语义 tokens（大文件开销巨大）
    client.server_capabilities.semanticTokensProvider = nil
  end,
})
