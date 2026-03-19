return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "artemave/workspace-diagnostics.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "leoluz/nvim-dap-go",
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      -- 补全和搜索工具已由 blink.cmp 和 fzf-lua 替代
      "saghen/blink.cmp",
      "rafamadriz/friendly-snippets",
      "saghen/blink.cmp",
    },
    config = function()
      -- telescope 已禁用，使用 fzf-lua
      vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references<CR>", { noremap = true, silent = true })
      local override = require "override.lspconfig"
      ---@diagnostic disable: undefined-global
      local on_attach = override.on_attach
      local capabilities = override.capabilities

      local dap = require "dap"
      local dapui = require "dapui"
      local dapgo = require "dap-go"
      -- local cmp = require "cmp"

      -- Using new vim.lsp.config API instead of deprecated require('lspconfig')

      local servers = {
        "vimls",
        "cssls",
        "clangd",
        -- "vls", -- Vue Language Server (已弃用，使用 volar)
        "prismals",
        "gopls",
        "jdtls",
        "emmet_ls",
        -- "java-language-server",
        -- "grammarly", -- 已禁用：grammarly-languageserver 存在 tree-sitter.wasm 加载问题
        "yamlls",
        "jsonls",
        "dockerls",
        "asm_lsp",
        "lua_ls",
        "biome",
        "eslint",
      }
      -- "rust_analyzer", "tsserver"
      -- dap.configurations.java = {
      --   {
      --     type = "java",
      --     request = "attach",
      --     name = "Debug (Attach) - Remote",
      --     hostName = "127.0.0.1",
      --     port = 5005,
      --   },
      -- }
      -- Java DAP 适配器（需要 jdtls 支持）
      -- dap.adapters.java = function(callback, config)
      --   vim.lsp.buf_request(0, "workspace/executeCommand", 
      --     { command = "vscode.java.startDebugSession" }, 
      --     function(err0, port)
      --       assert(not err0, vim.inspect(err0))
      --       callback { type = "server", host = "127.0.0.1", port = port }
      --     end)
      -- end

      dap.adapters.python = {
        type = "executable",
        command = os.getenv "HOME" .. "/.virtualenvs/tools/bin/python",
        args = { "-m", "debugpy.adapter" },
      }

      dapui.setup()
      dapgo.setup()

      -- require("nvim-dap-virtual-text").setup {
      --   -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
      --   display_callback = function(variable)
      --     local name = string.lower(variable.name)
      --     local value = string.lower(variable.value)
      --     if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
      --       return "*****"
      --     end

      --     if #variable.value > 15 then
      --       return " " .. string.sub(variable.value, 1, 15) .. "... "
      --     end

      --     return " " .. variable.value
      --   end,
      -- }

      local elixir_ls_debugger = vim.fn.exepath "elixir-ls-debugger"
      if elixir_ls_debugger ~= "" then
        dap.adapters.mix_task = {
          type = "executable",
          command = elixir_ls_debugger,
        }

        dap.configurations.elixir = {
          {
            type = "mix_task",
            name = "phoenix server",
            task = "phx.server",
            request = "launch",
            projectDir = "${workspaceFolder}",
            exitAfterTaskReturns = false,
            debugAutoInterpretAllModules = false,
          },
        }
      end

      vim.keymap.set("n", "<leader>bp", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>gb", dap.run_to_cursor)

      -- Eval var under cursor
      vim.keymap.set("n", "<space>?", function()
        require("dapui").eval(nil, { enter = true })
      end)

      vim.keymap.set("n", "<F1>", dap.continue)
      vim.keymap.set("n", "<F2>", dap.step_into)
      vim.keymap.set("n", "<F3>", dap.step_over)
      vim.keymap.set("n", "<F4>", dap.step_out)
      vim.keymap.set("n", "<F5>", dap.step_back)
      vim.keymap.set("n", "<F13>", dap.restart)

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      require("mason-lspconfig").setup {
        ensure_installed = servers,
        automatic_installation = true,
        handlers = {
          function(server_name)
            vim.lsp.config(server_name, {
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,

          --disabled
          -- ["tsserver"] = function() end,

          -- 配置 clangd 优化性能（禁用后台索引）
          ["clangd"] = function()
            vim.lsp.config("clangd", {
              on_attach = on_attach,
              capabilities = capabilities,
              cmd = {
                "clangd",
                "--log=error",              -- 只记录错误级别日志
                "--background-index=false", -- ❌ 禁用后台索引（卡顿来源）
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--fallback-style=llvm",
                "--pch-storage=memory",     -- 预编译头存内存，加快响应
                "--cross-file-rename",
              },
            })
          end,

          ["lua_ls"] = function()
            vim.lsp.config("lua_ls", {
              on_attach = on_attach,
              capabilities = capabilities,
              settings = {
                Lua = {
                  runtime = {
                    version = "LuaJIT",
                  },
                  diagnostics = {
                    globals = { "vim", "use" },
                  },
                  hint = {
                    enable = true,
                    setType = true,
                  },
                  telemetry = {
                    enable = false,
                  },
                  workspace = {
                    library = {
                      [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                      [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                      [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
                      [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
                    },
                    maxPreload = 100000,
                    preloadFileSize = 10000,
                  },
                },
              },
            })
          end,

          ["gopls"] = function()
            vim.lsp.config("gopls", {
              on_attach = on_attach,
              capabilities = capabilities,
              filetypes = { "go", "gomod", "gowork", "gosum", "goimpl" },
              settings = {
                gopls = {
                  buildFlags = { "-tags=wireinject" },
                  usePlaceholders = true,
                  completeUnimported = true,
                  vulncheck = "Imports",
                  gofumpt = true,
                  staticcheck = true,
                  analyses = {
                    nilness = true,
                    shadow = true,
                    unusedparams = true,
                    unusewrites = true,
                    fieldalignment = true,
                    useany = true,
                  },
                  codelenses = {
                    references = true,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true,
                    regenerate_cgo = true,
                    generate = true,
                    gc_details = false,
                    run_govulncheck = true,
                    vendor = true,
                  },
                  hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                  },
                },
              },
            })
          end,

          -- Vue LSP 配置已移除，建议手动安装和配置 @vue/language-server
          -- 或使用 typescript-tools.nvim 插件来支持 Vue 文件

          ["jdtls"] = function()
            vim.lsp.config("jdtls", {
              cmd = { "jdtls" },
              root_dir = function(fname)
                return vim.fs.find({"gradlew", ".git", "mvnw", "build.gradle", "build.gradle.kts", "pom.xml"}, {
                  path = fname,
                  upward = true
                })[1] and vim.fn.fnamemodify(vim.fs.find({"gradlew", ".git", "mvnw", "build.gradle", "build.gradle.kts", "pom.xml"}, {
                  path = fname,
                  upward = true
                })[1], ":h") or vim.fn.getcwd()
              end,
              filetypes = { "java", "kotlin" },
              on_attach = on_attach,
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
              settings = {
                java = {
                  configuration = {
                    runtimes = {
                      {
                        name = "JavaSE-21",
                        path = "/Users/simley/Library/Java/JavaVirtualMachines/azul-21.0.3/Contents/Home",
                      },
                    },
                  },
                },
              },
            })
          end,
        },
      }

      for _, lsp in ipairs(servers) do
        vim.lsp.config(lsp, {
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end

      -- vim.lsp.handlers["textDocument/hover"] = require("noice").hover
      -- vim.lsp.handlers["textDocument/signatureHelp"] = require("noice").signature

      -- If the buffer has been edited before formatting has completed, do not try to apply the changes
      vim.lsp.handlers["textDocument/formatting"] = function(err, result, ctx, _)
        if err ~= nil or result == nil then
          return
        end

        -- If the buffer hasn't been modified before the formatting has finished, update the buffer
        if not vim.api.nvim_buf_get_option(ctx.bufnr, "modified") then
          local view = vim.fn.winsaveview()
          local client = vim.lsp.get_client_by_id(ctx.client_id)
          vim.lsp.util.apply_text_edits(result, ctx.bufnr, client.offset_encoding)
          vim.fn.winrestview(view)
          if ctx.bufnr == vim.api.nvim_get_current_buf() or not ctx.bufnr then
            vim.api.nvim_command "noautocmd :update"
          end
        end
      end

      vim.diagnostic.config {
        virtual_lines = false,
        virtual_text = {
          source = "always",
          prefix = "■",
        },
        -- virtual_text = false,
        float = {
          source = "always",
          border = "rounded",
          format = function(diagnostic)
            if diagnostic.source == "" then
              return diagnostic.message
            end
            if diagnostic.source == "eslint" then
              return string.format(
                "%s [%s]",
                diagnostic.message,
                -- shows the name of the rule
                diagnostic.user_data.lsp.code
              )
            end
            return string.format("%s [%s]", diagnostic.message, diagnostic.source)
          end,
          suffix = function()
            return ""
          end,
          severity_sort = true,
          close_events = { "CursorMoved", "InsertEnter" },
        },
        signs = true,
        underline = false,
        update_in_insert = false,
        severity_sort = true,
      }
    end,
  },
}
