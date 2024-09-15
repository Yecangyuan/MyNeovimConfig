local settings = require "settings"

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
-- local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require("go.format").goimport()
  end,
  group = format_sync_grp,
})

if settings.editor.formatter == "conform" then
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
      require("conform").format { bufnr = args.buf }
    end,
  })
end

-- if settings.editor.vim_gas then
--   vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--     pattern = "*.S",
--     callback = function()
--       vim.bo.filetype = "asm"
--     end,
--   })
-- end

-- Disable LSP signature help for .S files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "S",
  callback = function()
    local clients = vim.lsp.get_active_clients()
    for _, client in ipairs(clients) do
      if client.server_capabilities.signatureHelpProvider then
        client.server_capabilities.signatureHelpProvider = false
      end
    end
  end,
})

if settings.editor.linter then
  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
      require("lint").try_lint()
    end,
  })
end
