-- 性能优化配置
-- 解决光标移动延迟、大文件卡顿等问题

local M = {}

-- 禁用 Treesitter 大文件解析
M.setup_treesitter_perf = function()
  -- 大文件检测：超过 100KB 或 1000 行的文件
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(args)
      local bufnr = args.buf
      local lines = vim.api.nvim_buf_line_count(bufnr)
      local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
      local size = ok and stats and stats.size or 0

      -- 大文件禁用 Treesitter 和 LSP
      if lines > 1000 or size > 100 * 1024 then
        vim.opt_local.foldmethod = "manual"
        vim.b[bufnr].large_file = true
        -- 禁用 Treesitter 高亮 (nvim-treesitter v1.0+)
        vim.treesitter.stop(bufnr)
        -- 回退到普通 indent
        vim.bo[bufnr].indentexpr = ""
        print("Large file detected: Treesitter disabled for performance")
      end
    end,
  })
end

-- 优化光标移动性能
M.setup_cursor_perf = function()
  -- 禁用光标行在插入模式下（减少重绘）
  vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function()
      vim.opt_local.cursorline = false
    end,
  })

  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
      vim.opt_local.cursorline = true
    end,
  })
end

-- 优化滚动性能
M.setup_scroll_perf = function()
  -- 减少屏幕重绘
  vim.opt.lazyredraw = false  -- 设为 true 可能导致闪烁，Neovim 0.10+ 已经优化了绘制

  -- 优化滚动行为
  vim.opt.scrolloff = 5
  vim.opt.sidescrolloff = 5

  -- 减少 syntax 同步范围（老版本语法高亮优化）
  local perf_augroup = vim.api.nvim_create_augroup("PerfSyntaxSync", { clear = true })
  vim.api.nvim_create_autocmd("BufEnter", {
    group = perf_augroup,
    pattern = "*",
    command = "syntax sync minlines=100 maxlines=200",
  })
end

-- 减少自动命令触发频率
M.setup_autocmd_perf = function()
  -- 增加更新间隔（减少 CursorHold 触发频率）
  vim.opt.updatetime = 300

  -- 减少键盘输入等待时间
  vim.opt.timeoutlen = 200
  vim.opt.ttimeoutlen = 0
end

-- 主入口
M.setup = function()
  -- disable_heavy_features 已迁移到 core/bootstrap.lua
  M.setup_autocmd_perf()
  M.setup_scroll_perf()
  M.setup_cursor_perf()
  M.setup_treesitter_perf()
end

return M
