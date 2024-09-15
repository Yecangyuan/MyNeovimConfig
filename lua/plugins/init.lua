local s = require "settings"

return {
  -- LSP 配置
  { import = "configs.lspconfig" }, -- 基础 LSP 配置
  { import = "configs.whichkey" }, -- 快捷键绑定配置
  { "williamboman/mason-lspconfig.nvim" }, -- 自动安装和配置 LSP 服务器

  -- 编辑器增强 (Editor)
  { import = "configs.editor.garbage_day", enabled = true }, -- 自动清理旧文件和缓存
  { import = "configs.editor.telescope", enabled = true }, -- 强大的模糊搜索工具
  { import = "configs.editor.neotree", enabled = true }, -- 文件树插件，文件浏览和管理
  { import = "configs.editor.cmp", enabled = true }, -- 代码补全插件
  { import = "configs.editor.mini", enabled = true }, -- 一系列微小的编辑器增强功能
  { import = "configs.editor.conform", enabled = true }, -- 代码格式化工具
  { import = "configs.editor.lint", enabled = s.editor.linter }, -- 代码静态分析工具
  { import = "configs.editor.aerial", enabled = s.editor.aerial }, -- 代码结构大纲
  { import = "configs.editor.copilot", enabled = s.editor.copilot }, -- GitHub Copilot 插件，AI 代码补全
  { import = "configs.editor.vim_gas", enabled = s.editor.vim_gas }, -- GAS 汇编语言支持
  { import = "configs.editor.copilot_chat", enabled = s.editor.copilot_chat }, -- Copilot 对话插件
  { import = "configs.editor.inc_rename", enabled = s.editor.inc_rename }, -- 增强的重命名工具
  { import = "configs.editor.oil", enabled = s.editor.oil }, -- 类似 Finder 的文件管理插件
  { import = "configs.editor.smart_splits", enabled = s.editor.smart_splits }, -- 智能窗口分割工具
  { import = "configs.editor.session", enabled = s.editor.sessions }, -- 会话管理插件
  { import = "configs.editor.workspaces", enabled = s.editor.sessions }, -- 工作空间管理
  { import = "configs.editor.goto_preview", enabled = s.editor.lsp_preview }, -- LSP 定义、引用的预览

  -- 语言支持 (Languages)
  { import = "configs.lang.typescript", enabled = s.lang.typescript }, -- TypeScript 语言支持
  { import = "configs.lang.hyprlang", enabled = s.lang.hyprlang }, -- Hyprland 配置语言支持
  { import = "configs.lang.markdown", enabled = s.lang.markdown }, -- Markdown 编辑支持
  { import = "configs.lang.golang", enabled = s.lang.go }, -- Go 语言支持

  -- 动作增强 (Motions)
  { import = "configs.motions.hop", enabled = s.motions.hop }, -- 快速跳转工具
  { import = "configs.motions.marks", enabled = s.motions.marks }, -- 标记管理和跳转
  { import = "configs.motions.harpoon", enabled = s.motions.harpoon }, -- 项目导航工具

  -- 界面优化 (UI)
  { import = "configs.ui.dressing", enabled = true }, -- 优化输入框和选择菜单样式
  { import = "configs.ui.toggleterm", enabled = true }, -- 内置终端管理工具
  { import = "configs.ui.bqf", enabled = true }, -- 增强 quickfix 列表的显示
  { import = "configs.ui.edgy", enabled = true }, -- 自定义侧边栏管理
  { import = "configs.ui.illuminate", enabled = s.ui.illuminate }, -- 高亮光标下的符号
  { import = "configs.ui.neoscroll", enabled = s.ui.smooth_scroll }, -- 平滑滚动效果
  { import = "configs.ui.noice", enabled = s.ui.noice }, -- 优化消息提示 UI
  { import = "configs.ui.trouble", enabled = s.ui.trouble }, -- 诊断和错误提示的列表
  -- { import = "configs.ui.ufo", enabled = s.ui.ufo }, -- 折叠代码的插件（目前禁用）
  { import = "configs.ui.windows", enabled = s.ui.windows }, -- 智能窗口管理工具
  { import = "configs.ui.hlslens", enabled = s.ui.hlslens }, -- 增强搜索高亮显示

  -- 实用工具 (Utility)
  { import = "configs.utility.lazygit", enabled = true }, -- 内置 Git 客户端
  { import = "configs.utility.numb", enabled = true }, -- 行号提示插件
  { import = "configs.utility.zoxide", enabled = true }, -- 目录跳转工具
  { import = "configs.utility.hawtkey", enabled = true }, -- 热键增强工具
  { import = "configs.utility.toggler", enabled = true }, -- 布尔值切换工具
  { import = "configs.utility.better_escape", enabled = true }, -- 优化 Esc 键行为
  { import = "configs.utility.comment_box", enabled = s.utility.comment_box }, -- 注释框插件
  { import = "configs.utility.lsplines", enabled = s.utility.lsplines }, -- LSP 报告的诊断信息可视化
  { import = "configs.utility.nerdy", enabled = s.utility.nerdy }, -- nerd 表情符号支持
  { import = "configs.utility.pomo", enabled = s.utility.pomodoro }, -- 番茄工作法插件
  { import = "configs.utility.todo_comments", enabled = s.utility.todo_comments }, -- 高亮 TODO 注释
  { import = "configs.utility.flote", enabled = s.utility.notes }, -- 笔记管理插件
  { import = "configs.utility.undotree", enabled = s.utility.undotree }, -- 撤销树插件
}
