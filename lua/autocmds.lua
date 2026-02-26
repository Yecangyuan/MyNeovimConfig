local settings = require "settings"

-- local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

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
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "S" then
      local clients = vim.lsp.get_active_clients()
      for _, client in ipairs(clients) do
        if client.server_capabilities.signatureHelpProvider then
          client.server_capabilities.signatureHelpProvider = false
        end
      end
    end
    vim.opt_local.formatoptions:remove { "c", "r", "o" }
  end,
})

if settings.editor.linter then
  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
      require("lint").try_lint()
    end,
  })
end
