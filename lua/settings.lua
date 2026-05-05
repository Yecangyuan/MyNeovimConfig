local M = {}

M.lang = {
  typescript = true,
  javascript = true,
  rust = true,
  go = true,
  lua = true,
  json = true,
  yaml = true,
  markdown = true,
  sh = true,
  bash = true,
  fish = true,
  cpp = true,
  c = true,
  norg = true,
  hyprland = true,
  html = true,
  css = true,
  vue = true,
}

M.editor = {
  lsp = false,
  completion = false,
  formatter = "confrom", -- "null-ls" or "confrom"
  linter = false,
  copilot = false,
  vim_gas = true,
  copilot_chat = false,
  dap = true,
  compiler = true,
  aerial = false,
  inc_rename = false,
  hover = false,
  lsp_preview = false,
  oil = true,
  sessions = true,
}

M.ui = {
  trouble = false,
  code_actions = false,
  smooth_scroll = true,
  lens = false,
  mode_indicator = true,
  notify = true,
  noice = true,
  split_animation = true,
  illuminate = true,
  ufo = false,
  hlslens = true,
}

M.motions = {
  harpoon = true,
  hop = true,
}

M.multiplexer = true

M.utility = {
  lsplines = false,
  nerdy = true,
  persist = true,
  git = true,
  obsidian = false,
  todo_comments = true,
  comment_box = true,
  pomodoro = true,
  notes = true,
  undotree = true,
}

return M
