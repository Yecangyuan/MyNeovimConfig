return {
  "nvim-treesitter/nvim-treesitter-context",
  event = "BufReadPost",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    max_lines = 3, -- 顶部最多保留 3 行上下文，避免占用过多可视行
    mode = "cursor",
  },
}
