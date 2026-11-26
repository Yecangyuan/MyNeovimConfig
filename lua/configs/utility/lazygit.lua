return {
  "kdheepak/lazygit.nvim",
  cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
  keys = {
    {
      "<leader>lg",
      "<cmd> LazyGit<CR>",
      mode = "n",
      desc = "LazyGit",
    },
    {
      "<leader>gg",
      "<cmd> LazyGit<CR>",
      mode = "n",
      desc = "LazyGit",
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}
