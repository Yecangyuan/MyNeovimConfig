# Neovim 配置

这是我的个人Neovim配置，基于NvChad框架，并添加了许多功能增强插件。

## 已安装插件

### 核心框架
- **NvChad (v2.5)** - Neovim配置框架
- **lazy.nvim** - 插件管理器

### 编辑器增强
#### LSP相关
- **nvim-lspconfig**, **mason.nvim**, **mason-lspconfig.nvim** - LSP支持
- **nvim-lint** - 代码静态分析
- **workspace-diagnostics.nvim** - 工作区诊断
- **lsp_lines.nvim** - LSP诊断可视化
- **lsp_signature.nvim** - 函数签名提示
- **goto-preview** - LSP定义预览

#### 补全与代码提示
- **nvim-cmp**及相关扩展 (buffer, path, nvim-lsp等)
- **LuaSnip**, **friendly-snippets** - 代码片段
- **copilot.vim** - GitHub Copilot
- **copilot.lua** - GitHub Copilot (lua配置)

#### 文件管理
- **nvim-tree.lua** - 文件树浏览器
- **oil.nvim** - 类似Finder的文件管理
- **telescope.nvim** - 模糊搜索
- **telescope-zoxide** - 目录跳转
- **zoxide.vim** - 快速目录导航

#### 代码格式化
- **conform.nvim** - 代码格式化工具

### 界面优化
#### 美化与UI
- **base46**, **ui** - NvChad主题
- **dressing.nvim** - 输入框美化
- **noice.nvim** - 通知美化
- **nvim-notify** - 通知系统
- **nvim-web-devicons** - 图标支持
- **edgy.nvim** - 边栏管理
- **windows.nvim** - 窗口管理
- **smart-splits.nvim** - 智能分屏
- **trouble.nvim** - 问题列表
- **nvim-bqf** - Quickfix列表增强

#### 终端
- **toggleterm.nvim** - 终端管理

#### 状态显示
- **gitsigns.nvim** - Git状态显示
- **which-key.nvim** - 快捷键提示
- **nvim-hlslens** - 搜索高亮增强
- **indent-blankline.nvim** - 缩进线
- **vim-illuminate** - 高亮相同单词

### 语言支持
#### 编程语言支持
- **nvim-treesitter** - 语法高亮和代码分析
- **go.nvim** - Go语言支持
- **typescript-tools.nvim**, **tsc.nvim** - TypeScript支持
- **tree-sitter-hyprlang** - Hyprland配置语言支持
- **vim-gas** - GAS汇编支持

#### Markdown支持
- **glow.nvim** - Markdown预览
- **peek.nvim**, **render-markdown.nvim** - Markdown渲染
- **img-clip.nvim** - 图片粘贴

### 工具类插件
#### Git相关
- **lazygit.nvim** - Git客户端集成

#### 开发工具
- **nvim-dap**及相关 - 调试支持
- **aerial.nvim** - 代码大纲
- **inc-rename.nvim** - 重命名工具
- **todo-comments.nvim** - TODO注释高亮
- **neovim-session-manager**, **workspaces.nvim** - 会话管理
- **garbage-day.nvim** - 旧文件清理

#### 导航与移动
- **hop.nvim** - 快速跳转
- **marks.nvim** - 标记管理
- **harpoon** - 项目导航
- **neoscroll.nvim** - 平滑滚动

#### 实用工具
- **pomo.nvim** - 番茄工作法计时器
- **flote.nvim** - 笔记管理
- **undotree** - 撤销历史树
- **nerdy.nvim** - nerd符号支持
- **comment-box.nvim** - 注释框
- **nvim-toggler** - 布尔值切换
- **avante.nvim** - AI插件(基于deepseek)
- **leetcode.nvim** - LeetCode刷题
- **hawtkeys.nvim** - 热键管理

## 插件更新常见问题

更新插件时可能会遇到以下问题：

### 1. 本地修改冲突

错误信息: `You have local changes in...`

解决方法:
```lua
-- 恢复插件到原始状态
:Lazy restore <插件名>

-- 或删除并重新安装
:Lazy clean <插件名>
:Lazy install <插件名>
```

### 2. 网络连接问题

错误信息: `Connection reset by peer` 或 `unable to access`

解决方法:
```lua
-- 在配置中添加Git代理
require("lazy").setup({
  -- 插件配置
}, {
  git = {
    -- 设置代理
    proxy = "http://127.0.0.1:端口号"
  }
})

-- 或使用镜像源
{ "github用户名/插件名", url = "https://mirror.ghproxy.com/https://github.com/github用户名/插件名.git" }
```

### 3. 子模块更新失败

错误信息: `Errors during submodule fetch`

解决方法:
```bash
# 在终端中运行
cd ~/.local/share/nvim/lazy/问题插件名
git submodule update --init --recursive --remote
```
