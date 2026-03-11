# Neovim 配置

这是我的个人 Neovim 配置，基于 NvChad 框架，并添加了许多功能增强插件。支持**正常模式**和**极速模式**两种运行模式。

## 特性概览

- 🚀 **双模式支持**: 正常模式（完整功能）和极速模式（最小延迟）
- ⚡ **性能优化**: 针对大文件和快速编辑进行了专门优化
- 🔧 **LSP 完整支持**: 多语言服务器配置，代码补全、诊断、格式化
- 🎨 **现代化 UI**: 基于 NvChad 的美观界面，支持通知美化、状态栏定制
- 📁 **智能文件管理**: 打开目录时自动启动文件树
- 🔍 **快速搜索**: 使用 fzf-lua 替代 telescope，更快的模糊搜索
- 🤖 **AI 辅助**: Copilot 和 Avante 配置支持

## 运行模式

### 正常模式（默认）
平衡性能和功能，启用所有插件。

### 极速模式 🏎️
通过设置 `vim.g.turbo_mode = true` 启用，仅加载最小插件集：
- 禁用大部分 UI 动画和视觉效果
- 禁用文件系统监视器
- 禁用 git 实时标记
- 禁用缩进线和光标行
- 最小化按键超时

在 `init.lua` 中取消注释以下行启用：
```lua
vim.g.turbo_mode = true
```

## 已安装插件

### 核心框架
- **[NvChad](https://github.com/NvChad/NvChad)** (v2.5) - Neovim 配置框架，提供主题和基础 UI
- **[lazy.nvim](https://github.com/folke/lazy.nvim)** - 现代插件管理器
- **[plenary.nvim](https://github.com/nvim-lua/plenary.nvim)** - Lua 工具库

### 编辑器增强

#### LSP 与代码智能
- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)** - LSP 客户端配置
- **[mason.nvim](https://github.com/williamboman/mason.nvim)** - LSP 服务器管理器
- **[mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)** - Mason 与 lspconfig 桥接
- **[nvim-lint](https://github.com/mfussenegger/nvim-lint)** - 代码静态分析（按需启用）
- **[aerial.nvim](https://github.com/stevearc/aerial.nvim)** - 代码大纲导航
- **[lsp_lines.nvim](https://github.com/ErichDonGubler/lsp_lines.nvim)** - LSP 诊断可视化
- **[goto-preview](https://github.com/rmagatti/goto-preview)** - 定义/引用预览窗口

#### 补全与代码片段
- **[blink.cmp](https://github.com/Saghen/blink.cmp)** - 极速代码补全引擎
- **[LuaSnip](https://github.com/L3MON4D3/LuaSnip)** - 代码片段引擎
- **[friendly-snippets](https://github.com/rafamadriz/friendly-snippets)** - 常用代码片段集合
- **[nvim-autopairs](https://github.com/windwp/nvim-autopairs)** - 自动括号配对

#### 搜索与导航
- **[fzf-lua](https://github.com/ibhagwan/fzf-lua)** - 基于 fzf 的模糊搜索（主搜索工具）
  - 文件搜索、live grep、recent files
  - LSP symbols、git commits
  - 集成 zoxide 目录跳转
- **[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)** - 备用模糊搜索（NvChad 内置）
- **[flash.nvim](https://github.com/folke/flash.nvim)** - 快速字符跳转
- **[harpoon](https://github.com/ThePrimeagen/harpoon)** - 项目文件快速切换
- **[marks.nvim](https://github.com/chentoast/marks.nvim)** - 标记管理增强
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** - 智能目录跳转
- **[numb.nvim](https://github.com/nacro90/numb.nvim)** - 行号预览跳转

#### 文件管理
- **[nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)** - 文件树浏览器
  - 打开目录时自动启动
  - 优化的性能设置（禁用文件监视）
- **[oil.nvim](https://github.com/stevearc/oil.nvim)** - 类似 Finder 的文件管理器（可选）

#### 编辑增强
- **[mini.nvim](https://github.com/echasnovski/mini.nvim)** - 多种编辑功能集合
- **[better-escape.nvim](https://github.com/max397574/better-escape.nvim)** - 更快的 ESC 键响应
- **[nvim-toggler](https://github.com/nguyenvukhang/nvim-toggler)** - 布尔值快速切换
- **[inc-rename.nvim](https://github.com/smjonas/inc-rename.nvim)** - 增量重命名
- **[todo-comments.nvim](https://github.com/folke/todo-comments.nvim)** - TODO 注释高亮
- **[comment-box.nvim](https://github.com/LudoPinelli/comment-box.nvim)** - 美化注释框
- **[undotree](https://github.com/mbbill/undotree)** - 撤销历史可视化

### 界面优化

#### 美化与 UI
- **[base46](https://github.com/NvChad/base46)** - NvChad 主题系统
- **[NvChad/ui](https://github.com/NvChad/ui)** - 状态栏、标签页等 UI 组件
- **[dressing.nvim](https://github.com/stevearc/dressing.nvim)** - 输入框和选择框美化
- **[noice.nvim](https://github.com/folke/noice.nvim)** - 命令行、消息、通知美化
- **[nvim-notify](https://github.com/rcarriga/nvim-notify)** - 通知系统（修复了 max_line_width 错误）
- **[nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)** - 文件图标
- **[indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)** - 缩进线（极速模式禁用）
- **[nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua)** - 颜色代码高亮

#### 窗口与布局
- **[edgy.nvim](https://github.com/folke/edgy.nvim)** - 边栏布局管理
- **[windows.nvim](https://github.com/anuvyklack/windows.nvim)** - 窗口自动调整大小
- **[smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim)** - 智能分屏导航
- **[toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)** - 终端管理

#### 信息展示
- **[trouble.nvim](https://github.com/folke/trouble.nvim)** - 诊断列表
- **[nvim-bqf](https://github.com/kevinhwang91/nvim-bqf)** - Quickfix 列表增强
- **[nvim-hlslens](https://github.com/kevinhwang91/nvim-hlslens)** - 搜索结果计数
- **[which-key.nvim](https://github.com/folke/which-key.nvim)** - 快捷键提示

### 语言支持

#### 语法与解析
- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** - 语法树解析，代码高亮

#### 语言特定
- **[typescript-tools.nvim](https://github.com/pmizio/typescript-tools.nvim)** - TypeScript 支持
- **[go.nvim](https://github.com/ray-x/go.nvim)** - Go 语言支持
- **[tree-sitter-hyprlang](https://github.com/luckasRanarison/tree-sitter-hyprlang)** - Hyprland 配置语言
- **[vim-gas](https://github.com/Shirk/vim-gas)** - GAS 汇编支持
- **[markdown 支持](lua/configs/lang/markdown.lua)** - Markdown 预览和渲染

### Git 集成
- **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)** - Git 状态标记（极速模式禁用）
- **[lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)** - Lazygit 集成（可选）

### 实用工具
- **[neovim-session-manager](https://github.com/Shatur/neovim-session-manager)** - 会话管理
- **[workspaces.nvim](https://github.com/natecraddock/workspaces.nvim)** - 工作区管理
- **[hawtkeys.nvim](https://github.com/tris203/hawtkeys.nvim)** - 快捷键查找
- **[leetcode.nvim](https://github.com/kawre/leetcode.nvim)** - LeetCode 刷题
- **[pomo.nvim](https://github.com/ncpa0cpl/pomo.nvim)** - 番茄钟计时器
- **[garbage-day.nvim](https://github.com/Zeioth/garbage-day.nvim)** - 自动清理内存
- **[conform.nvim](https://github.com/stevearc/conform.nvim)** - 代码格式化（可选）

### 开发工具
- **[nvim-dap](https://github.com/mfussenegger/nvim-dap)** - 调试适配器协议
- **[mason-nvim-dap.nvim](https://github.com/jay-babu/mason-nvim-dap.nvim)** - DAP 服务器管理
- **[nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls)** - Java 语言支持

## 快捷键速查

### 文件操作
| 快捷键 | 功能 |
|--------|------|
| `<leader>e` | 打开/关闭文件树 |
| `<leader>f` | 查找文件 (fzf) |
| `<leader>/` | 全局搜索 (live grep) |
| `<leader>so` | 最近文件 |
| `<leader>sb` | 缓冲区列表 |

### 代码导航
| 快捷键 | 功能 |
|--------|------|
| `gd` | 跳转到定义 |
| `gr` | 查找引用 |
| `<leader>ss` | 文档符号 |
| `s` | Flash 跳转 |
| `S` | Flash 选择 |

### LSP 操作
| 快捷键 | 功能 |
|--------|------|
| `K` | 显示文档 |
| `<leader>ca` | 代码操作 |
| `<leader>rn` | 重命名 |
| `<leader>cd` | 显示诊断 |

### 其他
| 快捷键 | 功能 |
|--------|------|
| `<leader>q` | 会话管理 |
| `<leader>z` | Zoxide 目录跳转 |
| `<leader>lg` | 打开 Lazygit |
| `<leader>tt` | 打开终端 |

## 配置结构

```
~/.config/nvim/
├── init.lua              # 入口文件，模式切换
├── lua/
│   ├── autocmds.lua      # 自动命令（含目录自动打开 nvim-tree）
│   ├── mappings.lua      # 键位映射
│   ├── options.lua       # 性能优化选项
│   ├── chadrc.lua        # NvChad 配置
│   ├── settings.lua      # 功能开关配置
│   ├── plugins/
│   │   └── init.lua      # 插件列表（含极速/正常模式）
│   ├── configs/
│   │   ├── editor/       # 编辑器插件配置
│   │   ├── lang/         # 语言支持配置
│   │   ├── motions/      # 移动导航配置
│   │   ├── ui/           # 界面配置
│   │   └── utility/      # 工具配置
│   └── nvchad/           # NvChad 核心配置
```

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
