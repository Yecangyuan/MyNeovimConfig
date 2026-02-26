-- 性能优化配置
-- 解决光标移动延迟、大文件卡顿等问题

local M = {}

-- 禁用 Treesitter 大文件解析
M.setup_treesitter_perf = function()
  local ok, ts = pcall(require, "nvim-treesitter.configs")
  if not ok then
    return
  end

  -- 大文件检测：超过 100KB 或 1000 行的文件
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(args)
      local bufnr = args.buf
      local lines = vim.api.nvim_buf_line_count(bufnr)
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
      local size = ok and stats and stats.size or 0

      -- 大文件禁用 Treesitter 和 LSP
      if lines > 1000 or size > 100 * 1024 then
        vim.opt_local.foldmethod = "manual"
        vim.b[bufnr].large_file = true
        -- 禁用 Treesitter 高亮
        vim.cmd("TSBufDisable highlight")
        vim.cmd("TSBufDisable indent")
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
  vim.cmd([[
    autocmd BufEnter * syntax sync minlines=100 maxlines=200
  ]])
end

-- 减少自动命令触发频率
M.setup_autocmd_perf = function()
  -- 增加更新间隔（减少 CursorHold 触发频率）
  vim.opt.updatetime = 300

  -- 减少键盘输入等待时间
  vim.opt.timeoutlen = 200
  vim.opt.ttimeoutlen = 0
end

-- 禁用重型功能
M.disable_heavy_features = function()
  -- 关闭 matchparen（Neovim 内置的括号匹配，可能卡）
  vim.g.loaded_matchparen = 1

  -- 关闭 2html
  vim.g.loaded_2html_plugin = 1

  -- 关闭 vimball
  vim.g.loaded_vimball = 1
  vim.g.loaded_vimballPlugin = 1

  -- 关闭 getscript
  vim.g.loaded_getscript = 1
  vim.g.loaded_getscriptPlugin = 1

  -- 关闭 logipat
  vim.g.loaded_logipat = 1

  -- 关闭 rrhelper
  vim.g.loaded_rrhelper = 1

  -- 关闭 spellfile
  vim.g.loaded_spellfile_plugin = 1

  -- 关闭 tar
  vim.g.loaded_tar = 1
  vim.g.loaded_tarPlugin = 1

  -- 关闭 zip
  vim.g.loaded_zip = 1
  vim.g.loaded_zipPlugin = 1

  -- 关闭 tutor
  vim.g.loaded_tutor = 1

  -- 关闭 netrw（你使用 nvim-tree）
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1
end

-- 主入口
M.setup = function()
  M.disable_heavy_features()
  M.setup_autocmd_perf()
  M.setup_scroll_perf()
  M.setup_cursor_perf()
  M.setup_treesitter_perf()
end

return M
