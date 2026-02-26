-- 🚀 极速模式启动配置
-- 复制此文件内容到 init.lua 以启用极速模式
-- 或者运行 :luafile lua/fast_init.lua 临时测试

-- =============================================
-- 性能优先：禁用所有内置重型插件
-- =============================================
vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- 禁用几乎所有内置插件
vim.g.loaded_2html_plugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_logipat = 1
vim.g.loaded_matchparen = 1  -- 禁用括号匹配（卡顿来源之一）
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- =============================================
-- 极速模式核心选项
-- =============================================
local opt = vim.opt

-- 最小延迟
opt.updatetime = 100        -- 减少 CursorHold 触发间隔
opt.timeoutlen = 150        -- 减少按键等待时间
opt.ttimeoutlen = 0         -- 键码序列无等待

-- 禁用所有视觉特效
opt.cursorline = false      -- ❌ 禁用光标行（大大减少重绘）
opt.cursorcolumn = false    -- 禁用光标列
opt.relativenumber = false  -- ❌ 禁用相对行号（实时计算行号差）
opt.number = true           -- 只保留绝对行号
opt.signcolumn = "yes"      -- 但保持 signcolumn 稳定避免跳动

-- 滚动优化
opt.lazyredraw = false      -- Neovim 0.10+ 已经优化，不需要设为 true
opt.scrolloff = 0           -- 最小滚动偏移（减少计算）
opt.sidescrolloff = 0

-- 禁用折叠（计算密集）
opt.foldenable = false
opt.foldmethod = "manual"

-- 减少语法高亮范围
opt.synmaxcol = 200         -- 超过 200 列不再语法高亮

-- 禁用交换文件和备份（减少 IO）
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- 禁用鼠标（减少事件处理）
opt.mouse = ""

-- 更快的更新
opt.redrawtime = 1000       -- 语法高亮超时
opt.maxmempattern = 1000    -- 限制模式匹配内存

-- =============================================
-- 启动 lazy.nvim
-- =============================================
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- 加载极速模式插件配置
require("lazy").setup({
  { import = "plugins.fast" },  -- 使用极速模式插件列表
}, {
  defaults = { lazy = true },
  install = { colorscheme = { "nvchad" } },
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "matchit",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
})

-- 加载主题
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

-- 延迟加载映射
vim.schedule(function()
  require "mappings"
end)

print("🚀 极速模式已启动！")
