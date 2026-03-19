-- Markdown 预览插件
return {
  -- 主流选择：iamcco/markdown-preview.nvim
  -- 使用浏览器预览，效果最好，社区最流行
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      -- 配置选项
      vim.g.mkdp_auto_start = 0        -- 不自动打开
      vim.g.mkdp_auto_close = 1        -- 切换 buffer 时自动关闭
      vim.g.mkdp_refresh_slow = 0      -- 实时刷新
      vim.g.mkdp_command_for_global = 0 -- 只对 markdown 文件启用
      vim.g.mkdp_open_to_the_world = 0 -- 只在本地打开
      vim.g.mkdp_open_ip = ''
      vim.g.mkdp_browser = ''          -- 使用默认浏览器
      vim.g.mkdp_echo_preview_url = 0
      vim.g.mkdp_page_title = '「${name}」'
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", mode = "n", desc = "Markdown Preview - Toggle" },
    },
    ft = { "markdown" },
  },

  -- 备选：渲染 markdown 到 nvim 内（不需要浏览器）
  -- 如果你不想用浏览器预览，可以启用这个
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,  -- 默认禁用，需要时启用
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown", "codecompanion" },
    opts = {
      -- 在 nvim 内渲染 markdown，不打开浏览器
    },
  },
}
