-- this was copied from nvchad
-- i only made minor changes, commented out the binds i want to change

local M = {}
local map = vim.keymap.set
local conf = require("nvconfig").ui.lsp

-- export on_attach & capabilities
M.on_attach = function(client, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Lsp Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Lsp Go to definition")
  map("n", "K", vim.lsp.buf.hover, opts "Lsp hover information")
  map("n", "gi", vim.lsp.buf.implementation, opts "Lsp Go to implementation")
  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Lsp Go to type definition")
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Lsp Code action")
  map("n", "gr", "<cmd>FzfLua lsp_references<CR>", { desc = "Fzf - LSP References" })

  -- setup signature popup（延迟加载避免启动卡顿）
  if conf.signature and client.server_capabilities.signatureHelpProvider then
    vim.defer_fn(function()
      require("nvchad.lsp.signature").setup(client, bufnr)
    end, 1000)
  end

  -- ⚡ 性能优化：禁用 LSP 文件监视（卡顿来源）
  if client.server_capabilities then
    client.server_capabilities.didChangeWatchedFiles = nil
  end

  -- workspace-diagnostics 会导致大项目卡顿，已禁用
end

-- disable semanticTokens
M.on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

-- 使用 blink.cmp 的 capabilities（比 nvim-cmp 更快）
-- 这里是 blink.cmp 的 get_lsp_capabilities() 的静态等价表。
-- 不直接调用它的原因：该方法 require "blink.cmp.sources.lib"，会把 blink 的整个
-- config/sources 提前拉进启动期，而它返回的只是一张不含运行时状态的常量表。
-- 若 blink 升级后需要同步，用以下断言比对：
--   local b = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
--   b.textDocument.completion.completionItem = M.capabilities.textDocument.completion.completionItem
--   assert(vim.deep_equal(M.capabilities, b))
local blink_lsp_capabilities = {
  textDocument = {
    completion = {
      completionItem = {
        snippetSupport = true,
        commitCharactersSupport = false,
        documentationFormat = { "markdown", "plaintext" },
        deprecatedSupport = true,
        preselectSupport = false,
        tagSupport = { valueSet = { 1 } },
        insertReplaceSupport = true,
        resolveSupport = {
          properties = { "documentation", "detail", "additionalTextEdits", "command", "data" },
        },
        insertTextModeSupport = { valueSet = { 1 } },
        labelDetailsSupport = true,
      },
      completionList = {
        itemDefaults = { "commitCharacters", "editRange", "insertTextFormat", "insertTextMode", "data" },
      },
      contextSupport = true,
      insertTextMode = 1,
    },
  },
}

-- 全局兜底：等价于 blink.cmp 自带的 plugin/blink-cmp.lua 注入到 vim.lsp.config("*") 的值，
-- 即不带 nvim 默认值的纯静态表。Neovim 在创建 client 时才把
-- make_client_capabilities() 叠在它下面（client.lua），所以这里保持"纯附加"语义。
-- 未显式配置 capabilities 的 server（stylua、typescript-tools 等）取这份。
M.global_capabilities = vim.deepcopy(blink_lsp_capabilities)

-- 各 server 显式使用的 capabilities：在静态表之上叠 nvim 默认值，再按本仓库偏好
-- 覆盖 completionItem（blink 的静态表把 preselectSupport/commitCharactersSupport
-- 设为 false，本仓库要 true）。与本次改动前的构造方式保持一致。
M.capabilities = vim.tbl_deep_extend("force", blink_lsp_capabilities, vim.lsp.protocol.make_client_capabilities())

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

return M
