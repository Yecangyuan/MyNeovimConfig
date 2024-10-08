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
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local telescope = require "telescope"
      vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>", { noremap = true, silent = true })
      local override = require "override.lspconfig"
      ---@diagnostic disable: undefined-global
      local on_attach = override.on_attach
      local capabilities = override.capabilities

      local dap = require "dap"
      local dapui = require "dapui"
      local dapgo = require "dap-go"
      -- local cmp = require "cmp"

      local lspconfig = require "lspconfig"

      local servers = {
        "vimls",
        "cssls",
        "clangd",
        "volar",
        "prismals",
        "gopls",
        "jdtls",
        "emmet_ls",
        -- "java-language-server",
        "grammarly",
        "yamlls",
        "jsonls",
        "dockerls",
        "asm_lsp",
        "lua_ls",
        "biome",
        "eslint",
      }
      -- "rust_analyzer", "tsserver"
      dap.configurations.java = {
        {
          type = "java",
          request = "attach",
          name = "Debug (Attach) - Remote",
          hostName = "127.0.0.1",
          port = 5005,
        },
      }

      dapui.setup()
      dapgo.setup()

      require("nvim-dap-virtual-text").setup {
        -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
        display_callback = function(variable)
          local name = string.lower(variable.name)
          local value = string.lower(variable.value)
          if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
            return "*****"
          end

          if #variable.value > 15 then
            return " " .. string.sub(variable.value, 1, 15) .. "... "
          end

          return " " .. variable.value
        end,
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
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end

      -- dap.require("mason-lspconfig").setup {
      --   ensure_installed = servers,
      --   automatic_installation = true,
      -- }

      require("mason-lspconfig").setup_handlers {

        function(server_name)
          lspconfig[server_name].setup {
            on_attach = on_attach,
            capabilities = capabilities,
          }
        end,

        --disabled
        ["tsserver"] = function() end,

        ["lua_ls"] = function()
          lspconfig["lua_ls"].setup {
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
          }
        end,

        ["gopls"] = function()
          lspconfig["gopls"].setup {
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
          }
        end,

        ["eslint"] = function()
          lspconfig["eslint"].setup {
            on_attach = on_attach,
            capabilities = capabilities,
            filetypes = {
              "javascript",
              "javascriptreact",
              "javascript.jsx",
              "typescript",
              "typescriptreact",
              "typescript.tsx",
              "vue",
              "astro",
            },
            cmd = { "vscode-eslint-language-server", "--stdio" },
            handlers = {
              ["eslint/confirmESLintExecution"] = function(_, result)
                if not result then
                  return
                end
                return 4 -- approved
              end,
              ["eslint/noLibrary"] = function()
                vim.notify("[lspconfig] Unable to find ESLint library.", vim.log.levels.WARN)
                return {}
              end,
              ["eslint/openDoc"] = function(_, result)
                if not result then
                  return
                end
                local sysname = vim.loop.os_uname().sysname
                if sysname:match "Windows_NT" then
                  os.execute(string.format("start %q", result.url))
                elseif sysname:match "Linux" then
                  os.execute(string.format("xdg-open %q", result.url))
                else
                  os.execute(string.format("open %q", result.url))
                end
                return {}
              end,
              ["eslint/probeFailed"] = function()
                vim.notify("[lspconfig] ESLint probe failed.", vim.log.levels.WARN)
                return {}
              end,
            },
            root_dir = require("lspconfig").util.root_pattern(
              ".eslintrc",
              ".eslintrc.js",
              ".eslintrc.cjs",
              ".eslintrc.yaml",
              ".eslintrc.yml",
              ".eslintrc.json",
              "package.json"
            ),
            settings = {
              codeAction = {
                disableRuleComment = {
                  enable = true,
                  location = "separateLine",
                },
                showDocumentation = {
                  enable = true,
                },
              },
              codeActionOnSave = {
                enable = false,
                mode = "all",
              },
              format = true,
              nodePath = "",
              onIgnoredFiles = "off",
              packageManager = "npm",
              quiet = false,
              rulesCustomizations = {},
              run = "onType",
              useESLintClass = false,
              validate = "on",
              workingDirectory = {
                mode = "location",
              },
            },
          }
        end,

        ["clangd"] = function()
          lspconfig["clangd"].setup {
            filetypes = { "c", "cc", "cpp", "objc", "objcpp", "cuda", "proto" },
            cmd = { "clangd" },
            on_attach = on_attach,
            capabilities = capabilities,
            root_dir = function(fname)
              return lspconfig.util.root_pattern(
                ".clangd",
                ".clang-tidy",
                ".clang-format",
                "compile_commands.json",
                "compile_flags.txt",
                "configure.ac",
                ".git"
              )(fname) or lspconfig.util.path.dirname(fname)
            end,
          }
        end,

        ["vimls"] = function()
          lspconfig["vimls"].setup {
            filetypes = { "vim" },
            cmd = { "vim-language-server", "--stdio" },
            on_attach = on_attach,
            flags = {
              debounce_text_changes = 500,
            },
            capabilities = capabilities,
            init_options = {
              diagnostic = {
                enable = true,
              },
              indexes = {
                count = 3,
                gap = 100,
                projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
                runtimepath = true,
              },
              isNeovim = true,
              iskeyword = "@,48-57,_,192-255,-#",
              runtimepath = "",
              suggest = {
                fromRuntimepath = true,
                fromVimruntime = true,
              },
              vimruntime = "",
            },
          }
        end,

        -- ["java-language-server"] = function()
        --   lspconfig["java-language-server"].setup {
        --     filetypes = { "java" },
        --     on_attach = on_attach,
        --     capabilities = capabilities,
        --   }
        -- end,

        ["jdtls"] = function()
          lspconfig["jdtls"].setup {
            cmd = { "jdtls" },
            root_dir = function(fname)
              return lspconfig.util.root_pattern("gradlew", ".git", "mvnw")(fname) or vim.fn.getcwd()
            end,
            filetypes = { "java" },
            on_attach = on_attach,
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            -- capabilities = capabilities,
          }
        end,

        -- ["bashls"] = function()
        --   lspconfig["bashls"].setup {
        --     cmd = { "bash-language-server", "start" },
        --     settings = {
        --       bashIde = {
        --         globPattern = "*@(.sh|.inc|.bash|.command)",
        --       },
        --     },
        --     filetypes = { "sh" },
        --     on_attach = on_attach,
        --     capabilities = capabilities,
        --   }
        -- end,

        ["tailwindcss"] = function()
          lspconfig["tailwindcss"].setup {
            filetypes = {
              "aspnetcorerazor",
              "astro",
              "astro-markdown",
              "blade",
              "clojure",
              "django-html",
              "htmldjango",
              "edge",
              "eelixir",
              "elixir",
              "ejs",
              "erb",
              "eruby",
              "gohtml",
              "gohtmltmpl",
              "haml",
              "handlebars",
              "hbs",
              "html",
              "html-eex",
              "heex",
              "jade",
              "leaf",
              "liquid",
              "markdown",
              "mdx",
              "mustache",
              "njk",
              "nunjucks",
              "php",
              "razor",
              "slim",
              "twig",
              "css",
              "less",
              "postcss",
              "sass",
              "scss",
              "stylus",
              "sugarss",
              "javascriptreact",
              "reason",
              "rescript",
              "typescriptreact",
              "vue",
              "svelte",
            },
          }
        end,
        ["volar"] = function()
          lspconfig["volar"].setup {
            capabilities = capabilities,
            on_attach = on_attach,
          }
        end,
      }

      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
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
