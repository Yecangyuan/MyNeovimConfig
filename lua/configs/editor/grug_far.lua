-- 批量搜索替换（grug-far）：与 fzf-lua 互补 —— fzf-lua 只负责搜索，
-- 这里负责跑 ripgrep 结果上的批量替换。configs/ui/edgy.lua 里已给它预留了
-- 右侧面板（ft = "grug-far"），打开时会自动被 edgy 接管。
return {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar", "GrugFarWithin" },
  keys = {
    { "<leader>sr", "<cmd>GrugFar<CR>", mode = { "n" }, desc = "GrugFar - Search & Replace" },
  },
  opts = {},
}
