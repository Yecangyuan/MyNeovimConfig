local s = require "settings"
local base = require "plugins.base"

-- =============================================
-- 正常模式 - 完整插件集
-- 从 base.lua 加载，按需覆盖 enabled
-- =============================================

local overrides = {
  ["configs.editor.mini"] = true,
  ["configs.editor.lint"] = s.editor.linter,
  ["configs.editor.aerial"] = s.editor.aerial,
  ["configs.editor.vim_gas"] = s.editor.vim_gas,
  ["configs.editor.inc_rename"] = s.editor.inc_rename,
  ["configs.editor.smart_splits"] = s.editor.smart_splits,
  ["configs.editor.session"] = s.editor.sessions,
  ["configs.motions.marks"] = s.motions.marks,
  ["configs.ui.dressing"] = true,
  ["configs.ui.toggleterm"] = true,
  ["configs.ui.bqf"] = true,
  ["configs.ui.edgy"] = true,
  ["configs.ui.noice"] = s.ui.noice,
  ["configs.ui.trouble"] = s.ui.trouble,
  ["configs.ui.windows"] = false,
  ["configs.ui.hlslens"] = s.ui.hlslens,
  ["configs.utility.numb"] = true,
  ["configs.utility.zoxide"] = true,
  ["configs.utility.hawtkey"] = true,
  ["configs.utility.toggler"] = true,
  ["configs.utility.comment_box"] = s.utility.comment_box,
  ["configs.utility.lsplines"] = s.utility.lsplines,
  ["configs.utility.todo_comments"] = s.utility.todo_comments,
  ["configs.utility.undotree"] = s.utility.undotree,
}

-- 应用覆盖
local result = {}
for _, spec in ipairs(base) do
  local key = type(spec) == "table" and spec.import
  if key and overrides[key] ~= nil then
    local copy = vim.deepcopy(spec)
    copy.enabled = overrides[key]
    table.insert(result, copy)
  else
    table.insert(result, spec)
  end
end

return result
