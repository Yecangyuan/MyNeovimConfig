-- fzf-lua: 比 telescope 更快的模糊搜索，使用原生 fzf 二进制
return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "FzfLua",
  keys = {
    { "<leader>f", "<cmd>FzfLua files<CR>", desc = "Fzf - Find Files" },
    { "<leader>sf", "<cmd>FzfLua files<CR>", desc = "Fzf - Find Files" },
    { "<leader>/", "<cmd>FzfLua live_grep<CR>", desc = "Fzf - Live Grep" },
    { "<leader>sg", "<cmd>FzfLua live_grep<CR>", desc = "Fzf - Live Grep" },
    { "<leader>so", "<cmd>FzfLua oldfiles<CR>", desc = "Fzf - Recent Files" },
    { "<leader>sb", "<cmd>FzfLua buffers<CR>", desc = "Fzf - Buffers" },
    { "<leader>sm", "<cmd>FzfLua marks<CR>", desc = "Fzf - Marks" },
    { "<leader>ss", "<cmd>FzfLua lsp_document_symbols<CR>", desc = "Fzf - Symbols" },
    { "<leader>sl", "<cmd>FzfLua resume<CR>", desc = "Fzf - Resume Last" },
    { "<leader>sk", "<cmd>FzfLua blines<CR>", desc = "Fzf - Find in Buffer" },
    { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Fzf - Git Commits" },
    { "<leader>sF", "<cmd>FzfLua grep_curbuf<CR>", desc = "Fzf - Find in Current Buffer" },
    { "<leader>sz", "<cmd>FzfLua zoxide<CR>", desc = "Fzf - Zoxide" },
    { "<leader>zx", "<cmd>FzfLua zoxide<CR>", desc = "Fzf - Zoxide" },
    { "gr", "<cmd>FzfLua lsp_references<CR>", desc = "Fzf - LSP References" },
    { "<leader>gr", "<cmd>FzfLua lsp_references<CR>", desc = "Fzf - LSP References" },
  },
  config = function()
    require("fzf-lua").setup({
      winopts = {
        height = 0.85,
        width = 0.80,
        preview = {
          hidden = "nohidden",
          vertical = "down:45%",
          horizontal = "right:50%",
        },
      },
      keymap = {
        builtin = {
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
        },
        fzf = {
          ["ctrl-d"] = "preview-page-down",
          ["ctrl-u"] = "preview-page-up",
          ["ctrl-q"] = "select-all+accept",
          -- fzf 默认 `tab:toggle+down`，而 files picker 启用了 `--multi`。
          -- 这会导致按 Tab 时先标记第一项再下移，回车反而打开被标记的第一项。
          ["tab"] = "down",
          ["shift-tab"] = "up",
          ["alt-t"] = "toggle",
        },
      },
      fzf_opts = {
        ["--layout"] = "reverse",
        ["--info"] = "inline",
      },
    })
  end,
}
