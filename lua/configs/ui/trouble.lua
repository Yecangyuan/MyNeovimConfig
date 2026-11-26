return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>wd", "<cmd>Trouble diagnostics toggle<CR>", desc = "Trouble - Workspace Diagnostics" },
    { "<leader>cq", "<cmd>Trouble qflist toggle<CR>", desc = "Trouble - Quickfix" },
  },
  opts = {
    focus = true,
    modes = {
      -- go.nvim still calls trouble.open("quickfix").
      quickfix = { mode = "qflist" },
    },
  },
}
