return {

  "hrsh7th/nvim-cmp",
  dependencies = {
    -- Auto-pairing plugin configuration
    {
      "windwp/nvim-autopairs",
      opts = {
        fast_wrap = {},
        disable_filetype = { "TelescopePrompt", "vim" },
      },
      config = function(_, opts)
        require("nvim-autopairs").setup(opts)
        local cmp_autopairs = require "nvim-autopairs.completion.cmp"
        require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
    },

    -- Tailwind CSS colorizer for specific file types
    {
      "roobert/tailwindcss-colorizer-cmp.nvim",
      ft = { "vue", "typescript", "typescriptreact", "javascript", "javascriptreact", "astro", "svelte" },
      config = function()
        require("tailwindcss-colorizer-cmp").setup {
          color_square_width = 2,
        }
      end,
    },

    -- LuaSnip integration with friendly snippets
    {
      "L3MON4D3/LuaSnip",
      dependencies = "rafamadriz/friendly-snippets",
      opts = {
        history = true,
        updateevents = "TextChanged,TextChangedI",
      },
      keys = {
        {
          "<C-s>",
          function()
            local ls = require "luasnip"
            if ls.choice_active() then
              ls.change_choice(1)
            end
          end,
          mode = { "i", "s" },
          silent = true,
        },
      },
    },

    -- Additional completion sources
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "ray-x/lsp_signature.nvim",
    "ray-x/cmp-treesitter",
    "delphinus/cmp-ctags",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
  },
  opts = {
    mapping = {
      ["<Tab>"] = require("cmp").mapping(function(fallback)
        if require("cmp").visible() then
          require("cmp").select_next_item()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),

      ["<S-Tab>"] = require("cmp").mapping(function(fallback)
        if require("cmp").visible() then
          require("cmp").select_prev_item()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    },

    sources = {
      { name = "codeium" },
      { name = "copilot" },
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "path" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "crates" },
    },
  },
}
