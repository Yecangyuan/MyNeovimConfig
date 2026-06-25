local settings = require "settings"

-- =============================================
-- 打开目录时自动启动 nvim-tree
-- =============================================
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() > 0 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      vim.cmd("cd " .. vim.fn.argv(0))
      local ok, api = pcall(require, "nvim-tree.api")
      if ok then
        api.tree.open()
      end
    end
  end,
})

-- =============================================
-- 在 dressing.nvim 输入框（新建/重命名文件）中禁用补全下拉框
-- =============================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = "DressingInput",
  callback = function(args)
    vim.b[args.buf].completion = false -- blink.cmp 尊重该变量
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
  callback = function(args)
    -- 只在非汇编文件时移除自动注释延续
    if vim.bo[args.buf].filetype ~= "S" and vim.bo[args.buf].filetype ~= "asm" then
      vim.opt_local.formatoptions:remove { "c", "r", "o" }
    end
  end,
})

-- .S 文件禁用 LSP signature help（仅影响当前 buffer）
vim.api.nvim_create_autocmd("LspAttach", {
  pattern = "*.S",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.signatureHelpProvider then
      client.server_capabilities.signatureHelpProvider = false
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
