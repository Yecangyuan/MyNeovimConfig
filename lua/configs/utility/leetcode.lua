return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
  lazy = false,
  dependencies = {
    "nvim-telescope/telescope.nvim",
    -- "ibhagwan/fzf-lua",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    -- configuration goes here
    ---@type lc.lang
    lang = "java",
    cn = { -- leetcode.cn
      enabled = true, ---@type boolean
      translator = true, ---@type boolean
      translate_problems = true, ---@type boolean
    },
  },
}
