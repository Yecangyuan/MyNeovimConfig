return {
  "stevearc/conform.nvim",
  event = "BufRead",
  config = function()
    require("conform").setup {
      lsp_fallback = true,
      formatters_by_ft = {
        javascript = { "biome" },
        typescript = { "biome" },
        lua = { "stylua" },
        json = { "prettier" },
        -- java = { "google-java-format" },
        yaml = { "yamlfmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        fish = { "fish_indent" },
        cpp = { "clang_format" },
        c = { "clang_format" },
        vue = { "prettierd", "prettier", stop_after_first = true },
        ["_"] = { "trim_whitespace" },
      },
      -- Disable automatic formatting on save; use the keymap below when you
      -- want to format manually.
      format_on_save = false,
    }
  end,
}
