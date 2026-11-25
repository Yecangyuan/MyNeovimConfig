return {
  {
    "neovim/nvim-lspconfig",
    -- 原先挂在 nvchad/plugins/init.lua 的那份声明上（那份 config 被本文件的 config
    -- 遮蔽、从未执行），现收敛到唯一来源，保留同样的懒加载触发方式。
    event = "User FilePost",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local override = require "override.lspconfig"
      ---@diagnostic disable: undefined-global
      local on_attach = override.on_attach
      local capabilities = override.capabilities

      -- 全局兜底：未显式配置 capabilities 的 server（如 stylua、typescript-tools）
      -- 取这份。显式设置可让 capabilities 不再依赖 blink.cmp 的加载时机（blink 已
      -- 延迟到 InsertEnter 加载，而它自带的 plugin/blink-cmp.lua 也会写
      -- vim.lsp.config("*")，届时会以本表为基础再合并，同值幂等）。
      --
      -- on_init 来自 override.lspconfig：chadrc.lua 里 lsp.semantic_tokens = false，
      -- 语义高亮需在 client 初始化时关掉。NvChad 原本把它挂在被遮蔽的
      -- nvchad.configs.lspconfig.defaults() 里，故从未生效；放在 "*" 上对所有
      -- server 兜底（vim.lsp.config 是深合并，blink 之后写 "*" 不会覆盖它）。
      vim.lsp.config("*", {
        capabilities = override.global_capabilities,
        on_init = override.on_init,
      })

      -- =============================================
      -- DAP 延迟加载（不再在打开文件时就加载 6 个调试插件）
      -- =============================================
      local function close_debug_windows()
        require("dapui").close()
        require("dap").repl.close()
      end

      local dap_initialized = false
      local function ensure_dap()
        if dap_initialized then return end
        dap_initialized = true

        local dap = require "dap"
        local dapui = require "dapui"
        local dapgo = require "dap-go"
        require("configs.dap.c")(dap)

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
        dap.listeners.before.event_terminated.dapui_config = close_debug_windows
        dap.listeners.before.event_exited.dapui_config = close_debug_windows
      end

      -- DAP 快捷键（首次使用时才加载 DAP）
      local function map_dap(key, action, desc)
        vim.keymap.set("n", key, function()
          ensure_dap()
          require("dap")[action]()
        end, { desc = "调试 - " .. desc })
      end

      map_dap("<leader>db", "toggle_breakpoint", "设置或取消断点")
      map_dap("<leader>dc", "continue", "启动或继续")
      map_dap("<leader>dn", "step_over", "单步跳过")
      map_dap("<leader>di", "step_into", "步入函数")
      map_dap("<leader>do", "step_out", "步出函数")
      map_dap("<leader>dp", "step_back", "反向单步")
      map_dap("<leader>dr", "restart", "重启")
      map_dap("<leader>gb", "run_to_cursor", "运行到光标处")

      vim.keymap.set("n", "<leader>dq", function()
        ensure_dap()
        require("dap").terminate { all = true, hierarchy = true }
        close_debug_windows()
      end, { desc = "调试 - 结束并关闭面板" })
      vim.keymap.set("n", "<space>?", function() ensure_dap(); require("dapui").eval(nil, { enter = true }) end)

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
        -- "jdtls", -- jdtls 由 nvim-jdtls（nvchad.configs.java）接管，避免双重启动
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

      -- =============================================
      -- mason-lspconfig v2：handlers 选项已被移除，
      -- 改用 vim.lsp.config 预置配置 + automatic_enable 自动启用
      -- =============================================
      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end

      -- 配置 clangd（启用后台索引以支持跨文件补全）
      vim.lsp.config("clangd", {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--log=error",              -- 只记录错误级别日志
          "--background-index",       -- ✅ 启用项目级后台索引（提升跨文件补全）
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--header-insertion-decorators=0", -- 补全项里不显示 include 装饰符
          "--completion-style=detailed",
          "--all-scopes-completion",  -- 可补全非当前作用域符号
          "--function-arg-placeholders",
          "--fallback-style=llvm",
          "--pch-storage=memory",     -- 预编译头存内存，加快响应
          "--cross-file-rename",
          "--enable-config",          -- 读取项目根目录的 .clangd 配置
          "--ranking-model=decision_forest", -- 决策森林排序补全结果
        },
      })

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

      -- 说明：mason-lspconfig v2 的 automatic_enable 默认会把【所有已安装】的
      -- server 都启用（不只 servers 列表），本机装了 grammarly 等已弃用的 server，
      -- 打开 markdown 就报 "RPC Error ... fetch failed"。这里关闭自动启用，
      -- 只显式启用 servers 列表（jdtls 由 nvim-jdtls 接管，本就不在列表里）。
      require("mason-lspconfig").setup {
        ensure_installed = servers,
        automatic_enable = false,
      }
      vim.lsp.enable(servers)
      -- Vue LSP 配置已移除，建议手动安装和配置 @vue/language-server
      -- 或使用 typescript-tools.nvim 插件来支持 Vue 文件

      -- If the buffer has been edited before formatting has completed, do not try to apply the changes
      -- 已迁移到 conform.nvim 处理；LSP 原生格式化请使用 vim.lsp.buf.format()

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
