local function preview(action)
  return function()
    require("goto-preview")[action]()
  end
end

return {
  "rmagatti/goto-preview",
  dependencies = { "rmagatti/logger.nvim" },
  keys = {
    { "<leader>pd", preview "goto_preview_definition", desc = "GotoPreview - Definition" },
    { "<leader>pt", preview "goto_preview_type_definition", desc = "GotoPreview - Type Definition" },
    { "<leader>pi", preview "goto_preview_implementation", desc = "GotoPreview - Implementation" },
    { "<leader>pD", preview "goto_preview_declaration", desc = "GotoPreview - Declaration" },
    { "<leader>pr", preview "goto_preview_references", desc = "GotoPreview - References" },
    { "<leader>px", preview "close_all_win", desc = "GotoPreview - Close All" },
  },
  opts = {
    border = { "↖", "─", "╮", "│", "╯", "─", "╰", "│" },
    references = { provider = "fzf_lua" },
  },
}
