# 🏎️ 极速模式完整指南

## 问题：光标移动延迟

你描述的 "按 hjkl 有几毫秒延迟" 是 Neovim 配置中**最常见**的性能问题。

### 罪魁祸首（按影响程度排序）

1. **smoothcursor.nvim** - 拦截所有光标移动并添加动画 ⭐ 最大元凶
2. **mini.indentscope** - 每次移动都计算当前缩进范围
3. **mini.cursorword** - 实时高亮当前单词
4. **indent-blankline** - 实时绘制缩进线
5. **cursorline** - 光标行高亮（需要重绘整行）
6. **relativenumber** - 相对行号（每次移动都重新计算行号差）
7. **gitsigns** - Git 标记实时更新
8. **Treesitter** - 大文件时语法高亮计算量巨大

## 解决方案

### 方案 1: 一键极速模式（推荐）

在 Neovim 中执行：

```vim
:FastMode
:q
```

重新启动 Neovim。

这将永久切换到极速模式，只加载 ~15 个核心插件。

### 方案 2: 临时测试极速模式

不重启测试效果：

```vim
:luafile lua/turbo_mode.lua
```

或者：

```vim
:TurboMode
```

### 方案 3: 手动逐项禁用

如果想知道具体是哪个插件导致的：

```vim
" 1. 禁用 Treesitter 高亮
:TSBufDisable highlight

" 2. 禁用光标行
:set nocursorline

" 3. 禁用相对行号
:set norelativenumber

" 4. 停止 LSP
:LspStop

" 5. 清除搜索高亮
:noh
```

每执行一条就测试 hjkl，看哪一步让速度变快。

### 方案 4: 大文件专用模式

如果只在特定文件感觉慢：

```vim
" 这些命令针对当前缓冲区
:TSBufDisable highlight
:TSBufDisable indent
:set nocursorline
:set norelativenumber
```

## 新命令

| 命令 | 作用 |
|------|------|
| `:FastMode` | 启用极速模式（下次启动生效） |
| `:FullMode` | 恢复完整功能模式 |
| `:ToggleMode` | 在两个模式间切换 |
| `:ModeStatus` | 查看当前模式 |
| `:TurboMode` | 临时启用 Turbo（不停机） |
| `:TurboModeOff` | 关闭临时 Turbo |

## 诊断脚本

运行性能检查：

```vim
:luafile lua/perf_check.lua
```

这将显示：
- 当前模式状态
- 所有性能敏感插件的加载情况
- 当前文件大小和 LSP 状态
- 针对性的优化建议

## 极速模式 vs 普通模式

| 功能 | 极速模式 | 普通模式 |
|------|----------|----------|
| 光标动画 | ❌ 无 | ✅ smoothcursor |
| 缩进线 | ❌ 无 | ✅ indent-blankline |
| 缩进范围 | ❌ 无 | ✅ mini.indentscope |
| 单词高亮 | ❌ 无 | ✅ mini.cursorword |
| 光标行 | ❌ 无 | ✅ 有 |
| 相对行号 | ❌ 无 | ✅ 有 |
| Git 标记 | ❌ 无 | ✅ gitsigns |
| 消息美化 | ❌ 无 | ✅ noice |
| 输入框美化 | ❌ 无 | ✅ dressing |
| 代码折叠 | ❌ 无 | ✅ 有 |
| LSP 补全 | ✅ 有 | ✅ 有 |
| 文件树 | ✅ 有 | ✅ 有 |
| 模糊搜索 | ✅ fzf-lua | ✅ fzf-lua |
| 快速跳转 | ✅ flash | ✅ flash |

## 推荐工作流

**日常开发**：使用极速模式，光标移动飞快

**需要调试/Git 查看**：
```vim
:FullMode
:q
" 重启后恢复所有功能
" 完成调试后
:FastMode
:q
```

**编辑大文件 (>1000 行)**：
```vim
" 自动启用极速模式，或手动：
:TSBufDisable highlight
:set nocursorline
:set norelativenumber
```

## 文件说明

| 文件 | 用途 |
|------|------|
| `init.lua` | 主配置，支持 `vim.g.turbo_mode` 开关 |
| `lua/plugins/init.lua` | 双模式插件列表 |
| `lua/plugins/fast.lua` | 极速模式专用插件列表（备用） |
| `lua/turbo_mode.lua` | 临时 Turbo 切换脚本 |
| `lua/fast_mode_toggle.lua` | 模式切换命令定义 |
| `lua/perf_check.lua` | 性能诊断脚本 |
| `SPEED_GUIDE.md` | 本指南 |
| `FAST_MODE.md` | 详细技术文档 |

## 如果还是慢

1. **检查终端本身**
   ```bash
   # 在终端运行，然后按 hjkl
   cat
   ```
   如果这里有延迟，是终端问题，不是 Neovim。

2. **测试干净 Neovim**
   ```bash
   nvim --clean
   ```
   如果 `--clean` 很快，说明是配置问题。

3. **检查输入法**
   切换输入法到英文再测试。

4. **检查 Tmux/Screen**
   如果在 tmux 中，尝试直接运行 nvim。

5. **硬件问题**
   在终端运行：
   ```bash
   # 测试终端输入延迟
   showkey -a
   # 然后按 hjkl，看响应时间
   ```

## 联系

如果极速模式下 hjkl 还是有延迟，请运行：

```vim
:luafile lua/perf_check.lua
```

然后把输出结果提供给我，我可以进一步帮你优化。
