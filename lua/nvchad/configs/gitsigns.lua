dofile(vim.g.base46_cache .. "git")

local options = {
  signs = {
    delete = { text = "󰍵" },
    changedelete = { text = "󱕖" },
  },

  -- ⚡ 性能优化：减少大项目中的卡顿
  max_file_length = 5000,        -- 超过 5000 行的文件禁用
  preview_config = { border = "rounded" },
  
  -- 延迟加载和节流
  attach_to_untracked = false,   -- 不附加到未跟踪文件
  
  -- 减少更新频率
  update_debounce = 100,
  
  -- 性能模式：在超过 10 个缓冲区的仓库中减少功能
  watch_gitdir = {
    interval = 1000,             -- 增加检查间隔（默认 1000ms）
    follow_files = true,
  },

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    
    -- 如果文件太大，禁用 gitsigns
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
    if ok and stats and stats.size > 1024 * 1024 then -- 超过 1MB
      return false
    end

    local function opts(desc)
      return { buffer = bufnr, desc = desc }
    end

    local map = vim.keymap.set

    map("n", "<leader>rh", gs.reset_hunk, opts "Reset Hunk")
    map("n", "<leader>ph", gs.preview_hunk, opts "Preview Hunk")
    map("n", "<leader>gb", gs.blame_line, opts "Blame Line")
  end,
}

return options
