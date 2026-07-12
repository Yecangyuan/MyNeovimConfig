return {
  "smoka7/hop.nvim",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("hop").setup {
      keys = "etovxqpdygfblzhckisuran",
      create_hl_autocmd = true,
      uppercase_labels = false,
      multi_windows = true,
    }
  end,
}
