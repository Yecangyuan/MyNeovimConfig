# 🏎️ 极速模式指南

如果你感觉 Neovim 光标移动有延迟，启用极速模式获得最流畅的体验。

## ⚡ 一键启用极速模式

### 方法 1: 临时启用（推荐先测试）

在 Neovim 中运行：

```vim
:lua vim.g.turbo_mode = true
:Lazy sync
:q
```

然后重新启动 Neovim。

### 方法 2: 永久启用

编辑 `init.lua`，取消注释这一行：

```lua
-- 取消注释下面这行启用极速模式
vim.g.turbo_mode = true
```

然后重启 Neovim。

### 方法 3: 临时 Turbo 命令（不重启）

```vim
:luafile lua/turbo_mode.lua
```

或者使用命令：

```vim
:TurboMode        " 启用极速模式
:TurboModeOff     " 关闭极速模式
:TurboStatus      " 查看状态
```

## 🚀 极速模式禁用了什么

### 完全禁用的插件

| 插件 | 正常功能 | 禁用原因 |
|------|----------|----------|
| smoothcursor.nvim | 光标动画 | 拦截 hjkl 移动 |
| mini.indentscope | 缩进范围指示 | 实时计算 |
| mini.cursorword | 单词高亮 | 频繁重绘 |
| indent-blankline | 缩进线 | 重绘开销 |
| noice.nvim | 消息美化 | 拦截消息系统 |
| dressing.nvim | 输入框美化 | 额外渲染层 |
| edgy.nvim | 侧边栏管理 | 窗口事件拦截 |
| windows.nvim | 窗口动画 | 尺寸计算 |
| hlslens.nvim | 搜索高亮 | 实时计算 |
| trouble.nvim | 诊断列表 | 后台更新 |
| gitsigns.nvim | Git 标记 | 实时更新（Turbo 模式会 detach） |
| nvim-treesitter | 语法高亮 | 大文件时卡顿（禁用高亮保留解析） |

### 禁用的功能

- ❌ 光标行高亮 (`cursorline`)
- ❌ 相对行号 (`relativenumber`)
- ❌ 代码折叠
- ❌ 鼠标支持（减少事件处理）
- ❌ 文件系统监视
- ❌ 括号匹配 (`matchparen`)
- ❌ 交换文件（减少 IO）

### 保留的核心功能

- ✅ LSP 代码补全 (blink.cmp)
- ✅ LSP 诊断和跳转
- ✅ 文件树 (nvim-tree，但禁用实时更新)
- ✅ 模糊搜索 (fzf-lua)
- ✅ 快速跳转 (flash.nvim)
- ✅ 语法解析 (treesitter，仅解析不高亮)

## 📊 性能对比

| 指标 | 正常模式 | 极速模式 |
|------|----------|----------|
| 启动插件数 | ~65+ | ~15 |
| 后台定时器 | 多 | 极少 |
| 光标移动事件 | 复杂 | 极简 |
| 屏幕重绘 | 频繁 | 最小化 |
| 大文件支持 | 可能卡顿 | 流畅 |

## 🔄 恢复完整功能

如果想恢复所有功能：

```vim
:lua vim.g.turbo_mode = false
:Lazy sync
:q
```

重启即可。

## 🎯 如果还是感觉慢

1. **检查你的终端**
   ```bash
   # 测试终端本身的速度
   cat
   # 然后按 hjkl，看是否有延迟
   ```

2. **禁用 LSP 测试**
   ```vim
   :LspStop
   ```
   如果 hjkl 变快了，说明 LSP 是瓶颈。

3. **检查 Treesitter**
   ```vim
   :TSBufDisable highlight
   :TSBufDisable indent
   ```

4. **使用最简配置测试**
   ```bash
   nvim --clean
   ```
   如果 `--clean` 模式下 hjkl 很快，说明是配置问题。

## 🐛 故障排查

### 问题：启动时报错

**解决**：运行 `:Lazy sync` 确保所有插件正确安装。

### 问题：某些功能不见了

**解决**：这是正常的，极速模式只保留核心功能。

### 问题：想保留某些被禁用的插件

**解决**：编辑 `lua/plugins/init.lua`，在极速模式部分将对应插件的 `enabled = false` 改为 `enabled = true`。

## 💡 建议

- 日常编码：使用**极速模式**，反应最快
- 需要调试/复杂操作：临时切换回**正常模式**
- 大文件编辑：必须使用**极速模式**
