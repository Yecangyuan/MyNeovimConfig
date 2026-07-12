-- =============================================
-- 模式选项管理
-- 集中管理普通模式与极速模式的性能相关选项
-- =============================================

local M = {}

M.options = {
  turbo = {
    updatetime = 100,
    timeoutlen = 150,
    ttimeoutlen = 0,
    cursorline = false,
    relativenumber = false,
    scrolloff = 0,
    sidescrolloff = 0,
    synmaxcol = 200,
  },
  normal = {
    updatetime = 250,
    timeoutlen = 200,
    ttimeoutlen = 1,
    cursorline = true,
    relativenumber = true,
    scrolloff = 5,
    sidescrolloff = 5,
    synmaxcol = 128,
  },
}

M.apply = function(mode_name)
  local opts = M.options[mode_name] or M.options.normal
  for key, value in pairs(opts) do
    vim.opt[key] = value
  end
end

M.is_turbo = function()
  return vim.g.turbo_mode == true
end

M.current = function()
  return M.is_turbo() and "turbo" or "normal"
end

return M
