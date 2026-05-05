local settings = require "settings"

-- =============================================
-- 打开目录时自动启动 nvim-tree
-- =============================================
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- 检查是否有参数且参数是目录
    if vim.fn.argc() > 0 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      -- 切换到该目录
      vim.cmd("cd " .. vim.fn.argv(0))
      -- 打开 nvim-tree
      require("nvim-tree.api").tree.open()
    end
  end,
})

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
      local clients = vim.lsp.get_clients()
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

