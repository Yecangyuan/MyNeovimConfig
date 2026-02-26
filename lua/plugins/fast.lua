-- 🚀 极速模式配置 - 禁用所有影响性能的插件
-- 只保留核心功能：LSP、补全、文件树、搜索

local s = require "settings"

return {
  -- =============================================
  -- ✅ 保留的核心插件（性能影响小）
  -- =============================================

  -- NvChad 核心
  { import = "nvchad.plugins" },

  -- LSP 配置
  { import = "configs.lspconfig" },
  { import = "configs.whichkey" },
  { "williamboman/mason-lspconfig.nvim" },

  -- 核心编辑功能
  { import = "configs.editor.blink_cmp", enabled = true },      -- 补全（Rust，很快）
  { import = "configs.editor.fzf", enabled = true },            -- 搜索（原生 fzf，很快）
  { import = "configs.editor.neotree", enabled = true },        -- 文件树
  { import = "configs.editor.flash", enabled = true },          -- 跳转（按需，不影响正常移动）

  -- Git（核心功能）
  -- gitsigns 是 NvChad 内置的，保留

  -- =============================================
  -- ❌ 禁用的性能杀手插件
  -- =============================================

  -- 视觉动画类
  -- { import = "configs.motions.smoothcursor", enabled = false },  -- 已禁用
  -- { import = "configs.ui.mini_animate", enabled = false },       -- 已禁用
  -- { import = "configs.ui.neoscroll", enabled = false },          -- 已禁用

  -- 实时计算类（光标移动时触发）
  { import = "configs.editor.mini", enabled = false },          -- ❌ 禁用 mini.indentscope + cursorword
  { import = "configs.ui.indentline", enabled = false },        -- ❌ 禁用缩进线（NvChad内置的）
  { import = "configs.ui.illuminate", enabled = false },        -- 已禁用
  { import = "configs.ui.hlslens", enabled = false },           -- ❌ 禁用搜索高亮增强

  -- UI 美化类（拦截消息和输入）
  { import = "configs.ui.noice", enabled = false },             -- ❌ 禁用 noice（消息美化）
  { import = "configs.ui.dressing", enabled = false },          -- ❌ 禁用 dressing（输入框美化）
  { import = "configs.ui.edgy", enabled = false },              -- ❌ 禁用 edgy（侧边栏管理）
  { import = "configs.ui.windows", enabled = false },           -- ❌ 禁用 windows（窗口动画）

  -- 其他可能影响的
  { import = "configs.editor.garbage_day", enabled = false },   -- 后台清理，可能有影响
  { import = "configs.ui.toggleterm", enabled = false },        -- 终端管理（可用原生 :term）
  { import = "configs.ui.bqf", enabled = false },               -- quickfix 增强
  { import = "configs.ui.trouble", enabled = false },           -- 诊断列表（可用原生 quickfix）

  -- =============================================
  -- ⚠️ 可选保留（根据需求）
  -- =============================================

  -- LSP 增强（按需加载，影响小）
  { import = "configs.editor.inc_rename", enabled = s.editor.inc_rename },
  { import = "configs.editor.goto_preview", enabled = false },  -- 改为 false，影响窗口切换

  -- 项目导航
  { import = "configs.motions.harpoon", enabled = s.motions.harpoon },
  { import = "configs.motions.marks", enabled = false },        -- ❌ 禁用标记增强

  -- 会话管理
  { import = "configs.editor.session", enabled = false },       -- ❌ 禁用自动会话
  { import = "configs.editor.workspaces", enabled = false },    -- ❌ 禁用工作区

  -- 代码结构
  { import = "configs.editor.aerial", enabled = false },        -- ❌ 禁用大纲

  -- 语言支持（按需）
  { import = "configs.lang.typescript", enabled = s.lang.typescript },
  { import = "configs.lang.golang", enabled = s.lang.go },
  { import = "configs.lang.markdown", enabled = false },        -- ❌ 禁用 Markdown 增强
  { import = "configs.lang.hyprlang", enabled = false },        -- ❌ 禁用 Hyprland 语法

  -- 代码质量（影响小但后台运行）
  { import = "configs.editor.lint", enabled = false },          -- ❌ 禁用自动 lint
  { import = "configs.utility.lsplines", enabled = false },     -- ❌ 禁用诊断可视化
  { import = "configs.utility.todo_comments", enabled = false }, -- ❌ 禁用 TODO 高亮

  -- 实用工具（大部分禁用）
  { import = "configs.utility.numb", enabled = false },         -- ❌ 禁行号预览
  { import = "configs.utility.zoxide", enabled = false },       -- ❌ 禁用 zoxide
  { import = "configs.utility.hawtkey", enabled = false },      -- ❌ 禁用热键分析
  { import = "configs.utility.toggler", enabled = false },      -- ❌ 禁用布尔切换
  { import = "configs.utility.better_escape", enabled = true }, -- ✅ 保留：优化 jk 退出
  { import = "configs.utility.comment_box", enabled = false },  -- ❌ 禁用注释框
  { import = "configs.utility.undotree", enabled = false },     -- ❌ 禁用撤销树
  { import = "configs.utility.leetcode", enabled = false },     -- ❌ 禁用 LeetCode

  -- 其他
  { import = "configs.editor.vim_gas", enabled = false },       -- ❌ 禁用汇编支持
  { import = "configs.editor.smart_splits", enabled = false },  -- ❌ 禁用智能分割
}
