return {
  "SilverofLight/kd_translate.nvim",
  cmd = { "TranslateNormal", "TranslateVisual" },
  keys = {
    { mode = { "n" }, "<leader>tt", "<cmd>TranslateNormal<CR>", desc = "kd - 翻译光标下的单词" },
    { mode = { "v" }, "<leader>tt", "<cmd>TranslateVisual<CR>", desc = "kd - 翻译选中的文本" },
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