return {
  "SilverofLight/kd_translate.nvim",
  cmd = { "TranslateNormal", "TranslateVisual" },
  keys = {
    -- <leader>t 原先是 split | terminal，已移除（终端统一走 toggleterm 的 <C-\>）。
    -- 该前缀下已无其他映射，因此 <leader>t 是单键直达，不会出现停顿后误触别的东西。
    { mode = { "n" }, "<leader>t", "<cmd>TranslateNormal<CR>", desc = "kd - 翻译光标下的单词" },
    { mode = { "v" }, "<leader>t", "<cmd>TranslateVisual<CR>", desc = "kd - 翻译选中的文本" },
  },
  config = function()
    -- 插件内部用 vim.system({"kd", ...}) 调用后端，不可配置路径。
    -- 从 GUI（neovide/Dock 启动）时 nvim 继承不到 ~/.local/bin，这里兜底补上。
    local bindir = vim.fn.expand "~" .. "/.local/bin"
    if vim.fn.isdirectory(bindir) == 1 and not vim.env.PATH:find(bindir, 1, true) then
      vim.env.PATH = bindir .. ":" .. vim.env.PATH
    end

    require("kd").setup {
      window = {
        width = 90,
        height = 18,
        border = "rounded",
        title = " 翻译 ",
        title_pos = "center",
        style = "minimal",
        relative = "cursor",
        focusable = true,
        row = 1,
        col = 0,
      },
      highlights = {
        word = { fg = "#f38ba8", bold = true, underline = false },
        phonetic = { fg = "#94e2d5", italic = true },
        level = { fg = "#fab387", italic = true },
      },
    }
  end,
}