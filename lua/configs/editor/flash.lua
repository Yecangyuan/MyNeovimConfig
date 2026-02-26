return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {},
  -- stylua: ignore
  keys = {
      -- 将 s 改为 <leader>s 以避免覆盖 Vim 原生的 substitute 功能
      { "<leader>fj", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash - Jump" },
      { "<leader>ft", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash - Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Flash - Remote" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Flash - Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Flash - Toggle Search" },
    },
}