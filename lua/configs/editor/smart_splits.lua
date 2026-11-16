return {
  "mrjones2014/smart-splits.nvim",
  event = "VeryLazy",
  config = function()
    -- smart-splits v3 移除了持久化 resize mode（原 resize_mode 整块），
    -- 并把 log_level 改成 log.level；这里只保留仍然有效的忽略列表。
    -- 旧配置把 NvimTree 当成 buftype 写了，它实际是 filetype。
    require("smart-splits").setup {
      ignored_buftypes = { "nofile", "quickfix", "prompt" },
      ignored_filetypes = { "NvimTree" },
    }
  end,
}
