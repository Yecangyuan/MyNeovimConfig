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
  aerial = false,
  inc_rename = false,
  oil = true,
  sessions = true,
  smart_splits = true,
}

M.ui = {
  trouble = false,
  notify = true,
  noice = true,
  illuminate = true,
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
