local M = {}

M.lang = {
  typescript = true,
  go = true,
  c = true,
  cpp = true,
  markdown = true,
  hyprland = true,
}

M.editor = {
  linter = false,
  copilot = false,
  copilot_chat = false,
  vim_gas = true,
  dap = true,
  aerial = true,
  inc_rename = false,
  oil = true,
  sessions = true,
  smart_splits = true,
}

M.ui = {
  trouble = true,
  notify = true,
  noice = true,
  -- 「高亮光标下单词」已由 configs/editor/mini.lua 的 mini.cursorword 承担，
  -- 故 illuminate 保持关闭；此开关现在真实生效（原先被 base.lua 硬编码 false 覆盖）。
  illuminate = false,
  hlslens = true,
}

M.motions = {
  harpoon = true,
  hop = true,
  marks = true,
}

M.utility = {
  lsplines = false,
  nerdy = true,
  todo_comments = true,
  comment_box = true,
  pomodoro = true,
  undotree = true,
}

return M
