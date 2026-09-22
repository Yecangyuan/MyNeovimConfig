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

  -- indent-blankline（极速模式下禁用）
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    enabled = not vim.g.turbo_mode,  -- 极速模式下禁用
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

  {
    "mfussenegger/nvim-dap",
    -- dapui / dap-go 是 configs/lspconfig.lua 的 ensure_dap() 直接 require 的模块，
    -- 此前没有任何地方声明，导致 F1–F5、<leader>bp 等键位一按就 module not found。
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio", -- nvim-dap-ui 运行时硬依赖，缺失时 require 直接报错
      "leoluz/nvim-dap-go",
    },
  },

  "jay-babu/mason-nvim-dap.nvim",

  -- 说明：nvim-tree / which-key / conform 的插件声明已统一收敛到
  -- lua/plugins/base.lua 引入的 configs/* 中（见 configs/editor/neotree.lua、
  -- configs/whichkey.lua、configs/editor/conform.lua），此处不再重复声明，
  -- 避免同一插件的两份 opts/config 相互遮蔽。

  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      require "nvchad.configs.java"
    end,
  },

  -- git stuff（极速模式下禁用实时标记）
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    enabled = not vim.g.turbo_mode,
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

  -- 说明：neovim/nvim-lspconfig 的声明同样已收敛到 configs/lspconfig.lua
  -- （原此处那份 config = nvchad.configs.lspconfig.defaults() 被它完全遮蔽、
  -- 从未执行，event = "User FilePost" 的懒加载触发方式已随之迁移过去）。

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
          vim.lsp.config("<YOUR_LSP_SERVER>", {
            capabilities = capabilities,
          })
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

  -- telescope 已禁用，使用 fzf-lua 替代
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   enabled = false,
  -- },

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
    -- opts 仍是本仓库唯一来源；原先这里还有一份 config，被 lua/plugins/base.lua
    -- 的 config 遮蔽、从未执行（ensure_installed 的延迟补装逻辑已迁移过去）。
    opts = function()
      return require "nvchad.configs.treesitter"
    end,
  },
}
