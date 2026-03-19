-- Markdown 预览插件
return {
  -- 1. 浏览器预览（效果最好，最完整）
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_page_title = '「${name}」'
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", mode = "n", desc = "Markdown Preview - Browser" },
    },
    ft = { "markdown" },
  },

  -- 2. nvim 内预览（渲染效果，不打开浏览器）
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    opts = {
      -- 在 nvim 内渲染 markdown
      render_modes = true,  -- 所有模式下都渲染
      anti_conceal = {
        enabled = true,  -- 允许在光标行显示隐藏字符
      },
    },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", mode = "n", desc = "Markdown Preview - Nvim Toggle" },
    },
  },
}
