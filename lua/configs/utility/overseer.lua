return {
  "stevearc/overseer.nvim",
  cmd = { "OverseerRun", "OverseerShell", "OverseerToggle", "OverseerTaskAction" },
  keys = {
    { "<leader>ob", "<cmd>OverseerRun<CR>", desc = "任务 - 选择并运行" },
    { "<leader>ot", "<cmd>OverseerToggle bottom<CR>", desc = "任务 - 打开或关闭列表" },
  },
  opts = {},
}
