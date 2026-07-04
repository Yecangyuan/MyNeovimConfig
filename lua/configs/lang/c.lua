-- =============================================
-- C/C++ 专属增强配置
-- 参考 golang.lua/typescript.lua 的语言模块思路
-- =============================================

local map = vim.keymap.set

local function clangd_on_attach(args)
  local bufnr = args.buf
  local client = vim.lsp.get_client_by_id(args.data and args.data.client_id or nil)

  local function opts(desc)
    return { buffer = bufnr, desc = desc, noremap = true, silent = true }
  end

  -- clangd_extensions 提供的命令
  map("n", "<leader>lh", "<CMD>ClangdSwitchSourceHeader<CR>", opts "C/C++ - 切换源文件/头文件")
  map("n", "<leader>lt", "<CMD>ClangdTypeHierarchy<CR>", opts "C/C++ - 类型层次")
  map("n", "<leader>ls", "<CMD>ClangdSymbolInfo<CR>", opts "C/C++ - 符号信息")
  map("n", "<leader>la", "<CMD>ClangdAST<CR>", opts "C/C++ - AST")
  map("v", "<leader>la", ":ClangdAST<CR>", opts "C/C++ - AST 范围")
  map("n", "<leader>lm", "<CMD>ClangdMemoryUsage<CR>", opts "C/C++ - 内存占用")

  -- 默认开启 inlay hints（只在 clangd 支持时）
  if client and client.server_capabilities.inlayHintProvider then
    local ok = pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
    if ok then
      map("n", "<leader>li", function()
        local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
        vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
      end, opts "C/C++ - 切换 Inlay Hints")
    end
  end
end

return {
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp" },
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("clangd_extensions").setup {
        extensions = {
          ast = {
            role_icons = {
              type = "",
              declaration = "",
              expression = "",
              statement = "",
              specifier = "",
              ["template argument"] = "",
            },
            kind_icons = {
              Compound = "",
              Recovery = "",
              TranslationUnit = "",
              PackExpansion = "",
              TemplateTypeParm = "",
              TemplateTemplateParm = "",
              TemplateParamObject = "",
            },
            highlights = { detail = "Comment" },
          },
          memory_usage = { border = "rounded" },
          symbol_info = { border = "rounded" },
        },
      }

      local group = vim.api.nvim_create_augroup("ClangdExtras", { clear = true })

      -- 只在 clangd 附加时绑定 keymap
      vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(args)
          local attached = vim.lsp.get_client_by_id(args.data.client_id)
          if attached and attached.name == "clangd" then
            clangd_on_attach(args)
          end
        end,
      })

      -- 处理插件加载晚于 LspAttach 的情况
      local buf = vim.api.nvim_get_current_buf()
      for _, c in ipairs(vim.lsp.get_clients { bufnr = buf, name = "clangd" }) do
        clangd_on_attach { buf = buf, data = { client_id = c.id } }
        break
      end
    end,
  },
}
