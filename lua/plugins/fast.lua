local s = require "settings"
local base = require "plugins.base"

-- =============================================
-- 🏎️ 极速模式 - 从 base.lua 加载，强制禁用性能敏感插件
-- =============================================

local fast_disabled = {
  ["configs.editor.mini"] = false,
  ["configs.editor.lint"] = false,
  ["configs.editor.aerial"] = false,
  ["configs.editor.vim_gas"] = false,
  ["configs.editor.inc_rename"] = s.editor.inc_rename,
  ["configs.editor.goto_preview"] = false,
  ["configs.editor.session"] = false,
  ["configs.editor.workspaces"] = false,
  ["configs.motions.hop"] = false,
  ["configs.motions.marks"] = false,
  ["configs.motions.harpoon"] = false,
  ["configs.motions.smoothcursor"] = false,
  ["configs.ui.mini_animate"] = false,
  ["configs.ui.dressing"] = false,
  ["configs.ui.toggleterm"] = false,
  ["configs.ui.bqf"] = false,
  ["configs.ui.edgy"] = false,
  ["configs.ui.illuminate"] = false,
  ["configs.ui.neoscroll"] = false,
  ["configs.ui.noice"] = false,
  ["configs.ui.trouble"] = false,
  ["configs.ui.windows"] = false,
  ["configs.ui.hlslens"] = false,
  ["configs.utility.lazygit"] = false,
  ["configs.utility.numb"] = false,
  ["configs.utility.zoxide"] = false,
  ["configs.utility.hawtkey"] = false,
  ["configs.utility.toggler"] = false,
  ["configs.utility.comment_box"] = false,
  ["configs.utility.lsplines"] = false,
  ["configs.utility.todo_comments"] = false,
  ["configs.utility.undotree"] = false,
  ["configs.utility.nerdy"] = false,
  ["configs.utility.pomo"] = false,
  ["configs.editor.vim_gas"] = false,
  ["configs.editor.smart_splits"] = false,
}

-- 应用覆盖
local result = {}
for _, spec in ipairs(base) do
  local key = type(spec) == "table" and spec.import
  if key and fast_disabled[key] ~= nil then
    local copy = vim.deepcopy(spec)
    copy.enabled = fast_disabled[key]
    table.insert(result, copy)
  else
    table.insert(result, spec)
  end
end

return result
