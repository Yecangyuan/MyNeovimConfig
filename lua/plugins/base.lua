local s = require "settings"

-- =============================================
-- 插件基础列表
-- init.lua 和 fast.lua 都基于此，只覆盖 enabled 差异
-- =============================================

return {
  -- NvChad 核心
  { import = "nvchad.plugins" },

  -- 覆盖 nvim-treesitter config 以兼容 nvim-treesitter v1.0+
  {
    "nvim-treesitter/nvim-treesitter",
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },

  -- 禁用 NvChad 默认的 nvim-cmp，使用 blink.cmp
  { "hrsh7th/nvim-cmp", enabled = false },

  -- LSP 配置
  { import = "configs.lspconfig" },
  { import = "configs.whichkey" },
  { "williamboman/mason-lspconfig.nvim" },

  -- 编辑器增强
  { import = "configs.editor.garbage_day", enabled = false },
  { import = "configs.editor.fzf", enabled = true },
  { import = "configs.editor.neotree", enabled = true },
  { import = "configs.editor.blink_cmp", enabled = true },
  { import = "configs.editor.mini", enabled = true },
  { import = "configs.editor.conform", enabled = true },
  { import = "configs.editor.lint", enabled = s.editor.linter },
  { import = "configs.editor.aerial", enabled = s.editor.aerial },
  { import = "configs.editor.vim_gas", enabled = s.editor.vim_gas },
  { import = "configs.editor.inc_rename", enabled = s.editor.inc_rename },
  { import = "configs.editor.smart_splits", enabled = s.editor.smart_splits },
  { import = "configs.editor.session", enabled = s.editor.sessions },
  { import = "configs.editor.workspaces", enabled = false },
  { import = "configs.editor.goto_preview", enabled = false },
  { import = "configs.editor.flash", enabled = true },

  -- 语言支持
  { import = "configs.lang.typescript", enabled = s.lang.typescript },
  { import = "configs.lang.hyprlang", enabled = false },
  { import = "configs.lang.markdown", enabled = true },
  { import = "configs.lang.golang", enabled = s.lang.go },
  { import = "configs.lang.c", enabled = s.lang.c or s.lang.cpp },

  -- 动作增强
  { import = "configs.motions.hop", enabled = false },
  { import = "configs.motions.marks", enabled = s.motions.marks },
  { import = "configs.motions.harpoon", enabled = false },
  { import = "configs.motions.smoothcursor", enabled = false },

  -- 界面优化
  { import = "configs.ui.mini_animate", enabled = false },
  { import = "configs.ui.dressing", enabled = true },
  { import = "configs.ui.toggleterm", enabled = true },
  { import = "configs.ui.bqf", enabled = true },
  { import = "configs.ui.edgy", enabled = true },
  { import = "configs.ui.illuminate", enabled = false },
  { import = "configs.ui.neoscroll", enabled = false },
  { import = "configs.ui.noice", enabled = s.ui.noice },
  { import = "configs.ui.trouble", enabled = s.ui.trouble },
  { import = "configs.ui.windows", enabled = false },
  { import = "configs.ui.hlslens", enabled = s.ui.hlslens },

  -- 实用工具
  { import = "configs.utility.lazygit", enabled = false },
  { import = "configs.utility.numb", enabled = true },
  { import = "configs.utility.zoxide", enabled = true },
  { import = "configs.utility.hawtkey", enabled = true },
  { import = "configs.utility.avante", enabled = false },
  { import = "configs.utility.toggler", enabled = true },
  { import = "configs.utility.leetcode", enabled = false },
  { import = "configs.utility.better_escape", enabled = true },
  { import = "configs.utility.comment_box", enabled = s.utility.comment_box },
  { import = "configs.utility.lsplines", enabled = s.utility.lsplines },
  { import = "configs.utility.nerdy", enabled = false },
  { import = "configs.utility.pomo", enabled = false },
  { import = "configs.utility.todo_comments", enabled = s.utility.todo_comments },
  { import = "configs.utility.flote", enabled = false },
  { import = "configs.utility.undotree", enabled = s.utility.undotree },
}
