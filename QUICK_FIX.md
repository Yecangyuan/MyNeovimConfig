# ⚡ hjkl 延迟快速修复指南

## 立即测试（30 秒）

### 步骤 1: 运行诊断

```vim
:luafile lua/find_delay.lua
```

这会显示所有可能导致延迟的原因。

### 步骤 2: 应用最小化配置测试

```vim
:luafile lua/minimal_test.lua
```

这会禁用**几乎所有**功能，只保留最基本的编辑。

**如果此时 hjkl 变快了**，说明是配置问题，继续步骤 3。
**如果还是慢**，说明是终端或系统问题，跳到「终端问题」部分。

### 步骤 3: 逐步启用功能找出元凶

从最小配置开始，逐一启用功能：

```vim
" 1. 测试基础功能
:set nocursorline
:set norelativenumber
:set hlsearch!

" 2. 测试 Treesitter
:TSBufDisable highlight

" 3. 测试 LSP
:LspStop

" 4. 检查映射
:nmap h
:nmap j
:nmap k
:nmap l
```

## 最常见的 5 个原因

### 1. 映射冲突 ⭐ 最常见

如果有映射以 `h`, `j`, `k`, `l` 开头，Vim 会等待超时。

```vim
" 检查是否有这样的映射
:nmap h
" 如果有输出类似：
" n  h          * <Plug>(some-plugin)
" 这就是问题！
```

**修复**：删除或修改这些映射。

### 2. cursorline ⭐ 第二常见

```vim
:set nocursorline
```

光标行高亮会导致每次移动都重绘整行。

### 3. relativenumber

```vim
:set norelativenumber
```

相对行号需要实时计算行号差值。

### 4. timeoutlen 过大

```vim
:set timeoutlen=100
:set ttimeoutlen=0
```

如果 timeoutlen 是 1000（1 秒），多字符映射会导致明显延迟。

### 5. Treesitter + 大文件

```vim
:TSBufDisable highlight
```

超过 1000 行的文件，Treesitter 高亮会明显卡顿。

## 终极测试：排除配置问题

```bash
# 完全干净的 Neovim
nvim --clean

# 然后测试 hjkl
```

如果 `--clean` 模式下很快，**100% 是配置问题**。
如果 `--clean` 也慢，**是终端或系统问题**。

## 终端问题排查

### 测试终端本身

```bash
# 在终端运行
cat

# 然后快速按 hjkl
# 如果感觉有延迟，是终端问题
# 按 Ctrl+C 退出
```

### 常见终端解决方案

**iTerm2 (macOS)**:
- Settings → Profiles → Terminal → Report terminal type: `xterm-256color`
- Settings → Profiles → Terminal → Check "Blinking cursor"（可能有关）

**Alacritty**:
```yaml
# ~/.config/alacritty/alacritty.yml
env:
  TERM: xterm-256color
```

**Tmux**:
```bash
# ~/.tmux.conf
set -sg escape-time 0
set -g repeat-time 0
```

**Windows Terminal**:
- 设置 → 默认值 → 高级 → 输入时渲染：关闭

## 原生 Vim 设置参考

在你的 `lua/options.lua` 中确保有这些：

```lua
-- 解决 hjkl 延迟的核心设置
vim.o.timeout = true
vim.o.ttimeout = true
vim.o.timeoutlen = 100       -- 或更小
vim.o.ttimeoutlen = 0        -- 键码无等待

-- 禁用重绘
vim.o.cursorline = false
vim.o.relativenumber = false
vim.o.lazyredraw = false     -- Neovim 0.10+ 可能不需要

-- 更新频率
vim.o.updatetime = 100
```

## 一键修复脚本

已经为你创建：

| 文件 | 用途 |
|------|------|
| `lua/find_delay.lua` | 诊断延迟原因 |
| `lua/minimal_test.lua` | 最小化配置测试 |
| `lua/native_speed.lua` | 完整原生优化 |

## 如果还是无法解决

请运行：

```vim
:luafile lua/find_delay.lua
```

然后把输出复制给我，我会帮你进一步分析。
