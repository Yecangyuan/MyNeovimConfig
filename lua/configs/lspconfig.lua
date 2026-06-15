return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local override = require "override.lspconfig"
      ---@diagnostic disable: undefined-global
      local on_attach = override.on_attach
      local capabilities = override.capabilities

      -- =============================================
      -- DAP 延迟加载（不再在打开文件时就加载 6 个调试插件）
      -- =============================================
      local dap_initialized = false
      local function ensure_dap()
        if dap_initialized then return end
        dap_initialized = true

        local dap = require "dap"
        local dapui = require "dapui"
        local dapgo = require "dap-go"

        local python_path = vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or vim.fn.exepath("python")
        if python_path == "" then
          python_path = os.getenv("HOME") .. "/.virtualenvs/tools/bin/python"
        end
        dap.adapters.python = {
          type = "executable",
          command = python_path,
          args = { "-m", "debugpy.adapter" },
        }

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

        dapui.setup()
        dapgo.setup()

        dap.listeners.before.attach.dapui_config = function() dapui.open() end
        dap.listeners.before.launch.dapui_config = function() dapui.open() end
        dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
        dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
      end

      -- DAP 快捷键（首次使用时才加载 DAP）
      vim.keymap.set("n", "<leader>bp", function() ensure_dap(); require("dap").toggle_breakpoint() end)
      vim.keymap.set("n", "<leader>gb", function() ensure_dap(); require("dap").run_to_cursor() end)
      vim.keymap.set("n", "<space>?", function() ensure_dap(); require("dapui").eval(nil, { enter = true }) end)
      vim.keymap.set("n", "<F1>", function() ensure_dap(); require("dap").continue() end)
      vim.keymap.set("n", "<F2>", function() ensure_dap(); require("dap").step_into() end)
      vim.keymap.set("n", "<F3>", function() ensure_dap(); require("dap").step_over() end)
      vim.keymap.set("n", "<F4>", function() ensure_dap(); require("dap").step_out() end)
      vim.keymap.set("n", "<F5>", function() ensure_dap(); require("dap").step_back() end)
      vim.keymap.set("n", "<F13>", function() ensure_dap(); require("dap").restart() end)

      -- =============================================
      -- LSP 服务器配置
      -- =============================================
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

      require("mason-lspconfig").setup {
        ensure_installed = servers,
        automatic_installation = true,
        handlers = {
          function(server_name)
            vim.lsp.config(server_name, {
              on_attach = on_attach,
              capabilities = capabilities,
            })
            vim.lsp.enable(server_name)
          end,

          --disabled
          -- ["tsserver"] = function() end,

          -- 配置 clangd（启用后台索引以支持跨文件补全）
          ["clangd"] = function()
            vim.lsp.config("clangd", {
              on_attach = on_attach,
              capabilities = capabilities,
              cmd = {
                "clangd",
                "--log=error",              -- 只记录错误级别日志
                "--background-index",       -- ✅ 启用项目级后台索引（提升跨文件补全）
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--fallback-style=llvm",
                "--pch-storage=memory",     -- 预编译头存内存，加快响应
                "--cross-file-rename",
              },
            })
            vim.lsp.enable("clangd")
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
                      vim.fn.expand "$VIMRUNTIME/lua",
                      vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
                      vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
                      vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
                    },
                    maxPreload = 100000,
                    preloadFileSize = 10000,
                  },
                },
              },
            })
            vim.lsp.enable("lua_ls")
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
            vim.lsp.enable("gopls")
          end,

          -- Vue LSP 配置已移除，建议手动安装和配置 @vue/language-server
          -- 或使用 typescript-tools.nvim 插件来支持 Vue 文件

          ["jdtls"] = function()
            local function find_root(fname)
              local markers = { "gradlew", ".git", "mvnw", "build.gradle", "build.gradle.kts", "pom.xml" }
              local found = vim.fs.find(markers, { path = fname, upward = true })[1]
              return found and vim.fn.fnamemodify(found, ":h") or vim.fn.getcwd()
            end

            vim.lsp.config("jdtls", {
              cmd = { "jdtls" },
              root_dir = function(fname)
                return find_root(fname)
              end,
              filetypes = { "java", "kotlin" },
              on_attach = on_attach,
              capabilities = capabilities,
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
            vim.lsp.enable("jdtls")
          end,
        },
      }

      -- vim.lsp.handlers["textDocument/hover"] = require("noice").hover
      -- vim.lsp.handlers["textDocument/signatureHelp"] = require("noice").signature

      -- If the buffer has been edited before formatting has completed, do not try to apply the changes
      vim.lsp.handlers["textDocument/formatting"] = function(err, result, ctx, _)
        if err ~= nil or result == nil then
          return
        end

        -- If the buffer hasn't been modified before the formatting has finished, update the buffer
        if not vim.api.nvim_get_option_value("modified", { bufnr = ctx.bufnr }) then
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
          source = "if_many",
          prefix = "■",
          spacing = 2,
        },
        float = {
          source = "if_many",
          border = "rounded",
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
