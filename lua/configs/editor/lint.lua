return {
  "mfussenegger/nvim-lint",
  -- event = "VeryLazy",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    local lint = require "lint"
    local has_cpplint = vim.fn.executable "cpplint" == 1

    lint.linters_by_ft = {
      typescript = { "eslint_d" },
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      kotlin = { "ktlint" },
      -- lua = { "luacheck" },
      json = { "jsonlint" },
      yaml = { "yamllint" },
      markdown = { "markdownlint" },
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      fish = { "fish" },
      cpp = has_cpplint and { "cpplint" } or {},
      c = has_cpplint and { "cpplint" } or {},
      vue = { "eslint_d" },
      -- typos
    }
  end,
}
