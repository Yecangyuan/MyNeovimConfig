vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- =============================================
-- 🚀 性能优化：禁用内置重型插件
-- =============================================
vim.g.loaded_2html_plugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_logipat = 1
vim.g.loaded_matchparen = 1  -- 禁用括号匹配（卡顿来源）
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
-- ⚡ 极速模式选项（减少延迟的关键）
-- =============================================
-- 取消注释下面这行启用极速模式
-- vim.g.turbo_mode = true

if vim.g.turbo_mode then
  -- 极速模式：最小延迟，最少特效
  vim.opt.updatetime = 100
  vim.opt.timeoutlen = 150
  vim.opt.ttimeoutlen = 0
  vim.opt.cursorline = false       -- 禁用光标行
  vim.opt.relativenumber = false   -- 禁用相对行号
  vim.opt.foldenable = false
  vim.opt.mouse = ""               -- 禁用鼠标
  vim.opt.scrolloff = 0
  vim.opt.synmaxcol = 200
else
  -- 正常模式：平衡性能和功能
  vim.opt.updatetime = 250
  vim.opt.timeoutlen = 200
  vim.opt.ttimeoutlen = 1
  vim.opt.cursorline = true
  vim.opt.relativenumber = true
end

-- =============================================
-- 启动 lazy.nvim
-- =============================================
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

-- =============================================
-- 选择插件配置
-- =============================================
-- 使用极速模式插件列表，或正常模式
local plugin_config = vim.g.turbo_mode and "plugins.fast" or "plugins"

local lazy_config = require "configs.lazy"

require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },
  { import = plugin_config },
}, lazy_config)

-- 加载主题
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- =============================================
-- 启动后提示
-- =============================================
if vim.g.turbo_mode then
  vim.schedule(function()
    print("🏎️  Turbo Mode 已启用 - 享受极致速度！")
  end)
end
