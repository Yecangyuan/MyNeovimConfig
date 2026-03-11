local s = require "settings"

-- 检测是否启用极速模式
local is_turbo = vim.g.turbo_mode

-- 根据模式返回不同的插件列表
if is_turbo then
  -- =============================================
  -- 🏎️ 极速模式 - 最小插件集
  -- =============================================
  return {
    -- 核心
    { import = "nvchad.plugins" },
    -- 禁用 NvChad 默认的 nvim-cmp，使用 blink.cmp
    { "hrsh7th/nvim-cmp", enabled = false },
    { import = "configs.lspconfig" },
    { import = "configs.whichkey" },
    { "williamboman/mason-lspconfig.nvim" },

    -- 编辑核心
    { import = "configs.editor.blink_cmp", enabled = true },
    { import = "configs.editor.fzf", enabled = true },
    { import = "configs.editor.neotree", enabled = true },
    { import = "configs.editor.flash", enabled = true },

    -- 全部禁用或按需
    { import = "configs.editor.mini", enabled = false },
    { import = "configs.editor.garbage_day", enabled = false },
    { import = "configs.editor.lint", enabled = false },
    { import = "configs.editor.aerial", enabled = false },
    { import = "configs.editor.vim_gas", enabled = false },
    { import = "configs.editor.inc_rename", enabled = false },
    { import = "configs.editor.smart_splits", enabled = false },
    { import = "configs.editor.session", enabled = false },
    { import = "configs.editor.workspaces", enabled = false },
    { import = "configs.editor.goto_preview", enabled = false },

    -- 语言（仅保留最常用的）
    { import = "configs.lang.typescript", enabled = s.lang.typescript },
    { import = "configs.lang.golang", enabled = s.lang.go },
    { import = "configs.lang.hyprlang", enabled = false },
    { import = "configs.lang.markdown", enabled = false },

    -- 动作（极简）
    { import = "configs.motions.hop", enabled = false },
    { import = "configs.motions.marks", enabled = false },
    { import = "configs.motions.harpoon", enabled = s.motions.harpoon },
    { import = "configs.motions.smoothcursor", enabled = false },

    -- UI（几乎全部禁用）
    { import = "configs.ui.mini_animate", enabled = false },
    { import = "configs.ui.dressing", enabled = false },
    { import = "configs.ui.toggleterm", enabled = false },
    { import = "configs.ui.bqf", enabled = false },
    { import = "configs.ui.edgy", enabled = false },
    { import = "configs.ui.illuminate", enabled = false },
    { import = "configs.ui.neoscroll", enabled = false },
    { import = "configs.ui.noice", enabled = false },
    { import = "configs.ui.trouble", enabled = false },
    { import = "configs.ui.windows", enabled = false },
    { import = "configs.ui.hlslens", enabled = false },

    -- 工具（几乎全部禁用）
    { import = "configs.utility.lazygit", enabled = false },
    { import = "configs.utility.numb", enabled = false },
    { import = "configs.utility.zoxide", enabled = false },
    { import = "configs.utility.hawtkey", enabled = false },
    { import = "configs.utility.avante", enabled = false },
    { import = "configs.utility.toggler", enabled = false },
    { import = "configs.utility.leetcode", enabled = false },
    { import = "configs.utility.better_escape", enabled = true },
    { import = "configs.utility.comment_box", enabled = false },
    { import = "configs.utility.lsplines", enabled = false },
    { import = "configs.utility.nerdy", enabled = false },
    { import = "configs.utility.pomo", enabled = false },
    { import = "configs.utility.todo_comments", enabled = false },
    { import = "configs.utility.flote", enabled = false },
    { import = "configs.utility.undotree", enabled = false },
  }
end

-- =============================================
-- 正常模式 - 完整插件集
-- =============================================
return {
  -- NvChad 核心插件
  { import = "nvchad.plugins" },
  -- 禁用 NvChad 默认的 nvim-cmp，使用 blink.cmp
  { "hrsh7th/nvim-cmp", enabled = false },

  -- LSP 配置
  { import = "configs.lspconfig" },
  { import = "configs.whichkey" },
  { "williamboman/mason-lspconfig.nvim" },

  -- 编辑器增强
  { import = "configs.editor.garbage_day", enabled = true },
  { import = "configs.editor.fzf", enabled = true },
  { import = "configs.editor.neotree", enabled = true },
  { import = "configs.editor.blink_cmp", enabled = true },
  { import = "configs.editor.mini", enabled = true },
  { import = "configs.editor.conform", enabled = false },
  { import = "configs.editor.lint", enabled = s.editor.linter },
  { import = "configs.editor.aerial", enabled = s.editor.aerial },
  { import = "configs.editor.vim_gas", enabled = s.editor.vim_gas },
  { import = "configs.editor.inc_rename", enabled = s.editor.inc_rename },
  { import = "configs.editor.smart_splits", enabled = s.editor.smart_splits },
  { import = "configs.editor.session", enabled = s.editor.sessions },
  { import = "configs.editor.workspaces", enabled = s.editor.sessions },
  { import = "configs.editor.goto_preview", enabled = s.editor.lsp_preview },
  { import = "configs.editor.flash", enabled = true },

  -- 语言支持
  { import = "configs.lang.typescript", enabled = s.lang.typescript },
  { import = "configs.lang.hyprlang", enabled = s.lang.hyprlang },
  { import = "configs.lang.markdown", enabled = s.lang.markdown },
  { import = "configs.lang.golang", enabled = s.lang.go },

  -- 动作增强
  { import = "configs.motions.hop", enabled = false },
  { import = "configs.motions.marks", enabled = s.motions.marks },
  { import = "configs.motions.harpoon", enabled = s.motions.harpoon },
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
  { import = "configs.ui.windows", enabled = s.ui.windows },
  { import = "configs.ui.hlslens", enabled = s.ui.hlslens },

  -- 实用工具
  { import = "configs.utility.lazygit", enabled = false },
  { import = "configs.utility.numb", enabled = true },
  { import = "configs.utility.zoxide", enabled = true },
  { import = "configs.utility.hawtkey", enabled = true },
  { import = "configs.utility.avante", enabled = false },
  { import = "configs.utility.toggler", enabled = true },
  { import = "configs.utility.leetcode", enabled = true },
  { import = "configs.utility.better_escape", enabled = true },
  { import = "configs.utility.comment_box", enabled = s.utility.comment_box },
  { import = "configs.utility.lsplines", enabled = s.utility.lsplines },
  { import = "configs.utility.nerdy", enabled = false },
  { import = "configs.utility.pomo", enabled = false },
  { import = "configs.utility.todo_comments", enabled = s.utility.todo_comments },
  { import = "configs.utility.flote", enabled = false },
  { import = "configs.utility.undotree", enabled = s.utility.undotree },
}
