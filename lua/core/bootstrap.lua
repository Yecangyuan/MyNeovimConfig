-- =============================================
-- 统一启动配置
-- 合并 init.lua 和 performance.lua 的重复逻辑
-- 作为所有设置的唯一真实来源
-- =============================================

-- 禁用内置重型插件（只需一处）
vim.g.loaded_2html_plugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_logipat = 1
vim.g.loaded_matchparen = 1
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

-- 兼容性 shim：NvChad v2.5 使用旧 API，Neovim 0.10+ 已弃用
if not vim.loop and vim.uv then
  vim.loop = vim.uv
end

-- 设置基础路径
vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- =============================================
-- turbo_mode 基础选项（唯一真实来源）
-- =============================================
if vim.g.turbo_mode then
  -- 极速模式：最小延迟，最少特效
  vim.opt.updatetime = 100
  vim.opt.timeoutlen = 150
  vim.opt.ttimeoutlen = 0
  vim.opt.cursorline = false
  vim.opt.relativenumber = false
  vim.opt.foldenable = false
  vim.opt.mouse = ""
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
