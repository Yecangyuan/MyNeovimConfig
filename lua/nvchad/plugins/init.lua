return {
  "nvim-lua/plenary.nvim",

  {
    "NvChad/base46",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "NvChad/ui",
    lazy = false,
    build = function()
      dofile(vim.fn.stdpath "data" .. "/lazy/ui/lua/nvchad_feedback.lua")()
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      dofile(vim.g.base46_cache .. "devicons")
      return { override = require "nvchad.icons.devicons" }
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    opts = {
      indent = { char = "│", highlight = "IblChar" },
      scope = { char = "│", highlight = "IblScopeChar" },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "blankline")

      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)

      dofile(vim.g.base46_cache .. "blankline")
    end,
  },

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "nvchad.configs.nvimtree"
    end,
  },

  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)
    end,
  },

  -- formatting!
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },

  -- dap
  -- {
  --   "jay-babu/mason-nvim-dap.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "javadbg", "javatest" })
  --   end,
  -- },

  -- {
  --   "WhoIsSethDaniel/mason-tool-installer.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.ensure_installed =
  --       require("astrocore").list_insert_unique(opts.ensure_installed, { "jdtls", "java-debug-adapter", "java-test" })
  --   end,
  -- },

  -- {
  --   "mfussenegger/nvim-jdtls",
  --   ft = { "java" },
  --   dependencies = {
  --     "williamboman/mason-lspconfig.nvim",
  --     {
  --       "AstroNvim/astrolsp",
  --       optional = true,
  --       ---@type AstroLSPOpts
  --       opts = {
  --         ---@diagnostic disable: missing-fields
  --         handlers = { jdtls = false },
  --       },
  --     },
  --   },
  --   opts = function(_, opts)
  --     local utils = require "astrocore"
  --     -- use this function notation to build some variables
  --     local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", ".project" }
  --     local root_dir = require("jdtls.setup").find_root(root_markers)
  --     -- calculate workspace dir
  --     local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  --     local workspace_dir = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name
  --     vim.fn.mkdir(workspace_dir, "p")

  --     -- validate operating system
  --     if not (vim.fn.has "mac" == 1 or vim.fn.has "unix" == 1 or vim.fn.has "win32" == 1) then
  --       utils.notify("jdtls: Could not detect valid OS", vim.log.levels.ERROR)
  --     end

  --     return utils.extend_tbl({
  --       cmd = {
  --         "java",
  --         "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  --         "-Dosgi.bundles.defaultStartLevel=4",
  --         "-Declipse.product=org.eclipse.jdt.ls.core.product",
  --         "-Dlog.protocol=true",
  --         "-Dlog.level=ALL",
  --         "-javaagent:" .. vim.fn.expand "$MASON/share/jdtls/lombok.jar",
  --         "-Xms1g",
  --         "--add-modules=ALL-SYSTEM",
  --         "--add-opens",
  --         "java.base/java.util=ALL-UNNAMED",
  --         "--add-opens",
  --         "java.base/java.lang=ALL-UNNAMED",
  --         "-jar",
  --         vim.fn.expand "$MASON/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
  --         "-configuration",
  --         vim.fn.expand "$MASON/share/jdtls/config",
  --         "-data",
  --         workspace_dir,
  --       },
  --       root_dir = root_dir,
  --       settings = {
  --         java = {
  --           eclipse = { downloadSources = true },
  --           configuration = { updateBuildConfiguration = "interactive" },
  --           maven = { downloadSources = true },
  --           implementationsCodeLens = { enabled = true },
  --           referencesCodeLens = { enabled = true },
  --           inlayHints = { parameterNames = { enabled = "all" } },
  --           signatureHelp = { enabled = true },
  --           completion = {
  --             favoriteStaticMembers = {
  --               "org.hamcrest.MatcherAssert.assertThat",
  --               "org.hamcrest.Matchers.*",
  --               "org.hamcrest.CoreMatchers.*",
  --               "org.junit.jupiter.api.Assertions.*",
  --               "java.util.Objects.requireNonNull",
  --               "java.util.Objects.requireNonNullElse",
  --               "org.mockito.Mockito.*",
  --             },
  --           },
  --           sources = {
  --             organizeImports = {
  --               starThreshold = 9999,
  --               staticStarThreshold = 9999,
  --             },
  --           },
  --         },
  --       },
  --       init_options = {
  --         bundles = {
  --           vim.fn.expand "$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar",
  --           -- unpack remaining bundles
  --           (table.unpack or unpack)(vim.split(vim.fn.glob "$MASON/share/java-test/*.jar", "\n", {})),
  --         },
  --       },
  --       handlers = {
  --         ["$/progress"] = function() end, -- disable progress updates.
  --       },
  --       filetypes = { "java" },
  --       on_attach = function(...)
  --         require("jdtls").setup_dap { hotcodereplace = "auto" }
  --         local astrolsp_avail, astrolsp = pcall(require, "astrolsp")
  --         if astrolsp_avail then
  --           astrolsp.on_attach(...)
  --         end
  --       end,
  --     }, opts)
  --   end,
  --   config = function(_, opts)
  --     -- setup autocmd on filetype detect java
  --     vim.api.nvim_create_autocmd("Filetype", {
  --       pattern = "java", -- autocmd to start jdtls
  --       callback = function()
  --         if opts.root_dir and opts.root_dir ~= "" then
  --           require("jdtls").start_or_attach(opts)
  --         else
  --           require("astrocore").notify("jdtls: root_dir not found. Please specify a root marker", vim.log.levels.ERROR)
  --         end
  --       end,
  --     })
  --     -- create autocmd to load main class configs on LspAttach.
  --     -- This ensures that the LSP is fully attached.
  --     -- See https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
  --     vim.api.nvim_create_autocmd("LspAttach", {
  --       pattern = "*.java",
  --       callback = function(args)
  --         local client = vim.lsp.get_client_by_id(args.data.client_id)
  --         -- ensure that only the jdtls client is activated
  --         if client.name == "jdtls" then
  --           require("jdtls.dap").setup_dap_main_class_configs()
  --         end
  --       end,
  --     })
  --   end,
  -- },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require "nvchad.configs.gitsigns"
    end,
  },

  -- lsp stuff
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require "nvchad.configs.mason"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
    end,
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "hrsh7th/cmp-cmdline",
        config = function()
          require("cmp").setup.cmdline({ "/", "?" }, {
            mapping = require("cmp").mapping.preset.cmdline(),
            sources = {
              { name = "buffer" },
            },
          })
        end,
      },
      {
        "hrsh7th/cmp-cmdline",
        config = function()
          require("cmp").setup.cmdline(":", {
            mapping = require("cmp").mapping.preset.cmdline(),
            sources = require("cmp").config.sources({
              { name = "path" },
            }, {
              { name = "cmdline" },
            }),
            matching = { disallow_symbol_nonprefix_matching = false },
          })
        end,
      },
      {
        "neovim/nvim-lspconfig",
        config = function()
          local capabilities = require("cmp_nvim_lsp").default_capabilities()
          -- Replace <YOUR_LSP_SERVER> with each LSP server you have enabled.
          require("lspconfig")["<YOUR_LSP_SERVER>"].setup {
            capabilities = capabilities,
          }
        end,
      },
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "nvchad.configs.luasnip"
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-vsnip",
        "hrsh7th/vim-vsnip",
        "dcampos/cmp-snippy",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      return require "nvchad.configs.cmp"
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require "nvchad.configs.telescope"
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "User FilePost",
    opts = {
      user_default_options = { names = false },
      filetypes = {
        "*",
        "!lazy",
      },
    },
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "nvchad.configs.treesitter"
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
