local wk = require "which-key"

return {
  "folke/which-key.nvim",
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  config = function(_, opts)
    dofile(vim.g.base46_cache .. "whichkey")
    require("which-key").setup(opts)

    wk.add {
      -- 将 which-key 映射规范更新为新的格式
      { "<leader>T", group = " Toggle" },
      { "<leader>Tn", group = " Line number" },
      { "<leader>b", group = "󰈔 Buffer" },
      { "<leader>c", group = "󰘦 Code" },
      { "<leader>co", group = " Copilot" },
      { "<leader>g", group = "󰊤 Git" },
      { "<leader>h", group = "󰛢 Harpoon/Hop" },
      { "<leader>l", group = "󱃕 Lists" },
      { "<leader>n", group = "󰐕 new" },
      { "<leader>o", group = "󰘖 Open" },
      { "<leader>p", group = " Preview" },
      { "<leader>q", group = "󰁯 Session" },
      { "<leader>r", group = " Refactor" },
      { "<leader>s", group = "󱦞 Search" },
      { "<leader>t", group = "󰙨 Test" },
      { "<leader>w", group = "󰉋 Workspace" },
      { "<leader>z", group = "󰍻 Extras" },
    }
  end,
  opts = {
    icons = {
      group = "", -- 禁用 + 以便使用 Nerf 字体
    },
  },
}
