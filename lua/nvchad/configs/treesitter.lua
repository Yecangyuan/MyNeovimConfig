pcall(function()
  dofile(vim.g.base46_cache .. "syntax")
  dofile(vim.g.base46_cache .. "treesitter")
end)

-- Neovim 0.12+: highlight/indent are built-in, only ensure_installed is needed
local options = {
  ensure_installed = { "c", "cpp", "lua", "luadoc", "printf", "vim", "vimdoc", "java" },
}

return options
