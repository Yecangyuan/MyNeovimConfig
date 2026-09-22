return {
  "j-hui/fidget.nvim",
  -- 必须有触发条件：此前只有 opts，lazy 没有加载时机，插件实际从未加载过
  -- （LSP 进度条等于没生效）。挂在 LspAttach 上，不占启动时间。
  event = "LspAttach",
  opts = {},
}
