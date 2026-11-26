local function select_object(capture)
  return function()
    require("nvim-treesitter-textobjects.select").select_textobject(capture, "textobjects")
  end
end

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    select = { selection_modes = { ["@function.outer"] = "V" } },
    move = { set_jumps = true },
  },
  keys = {
    { "af", select_object "@function.outer", mode = { "x", "o" }, desc = "整个函数" },
    { "if", select_object "@function.inner", mode = { "x", "o" }, desc = "函数体" },
    { "aa", select_object "@parameter.outer", mode = { "x", "o" }, desc = "参数和分隔符" },
    { "ia", select_object "@parameter.inner", mode = { "x", "o" }, desc = "参数内容" },
    {
      "<leader>jn",
      function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
      end,
      desc = "下一个函数",
    },
    {
      "<leader>jp",
      function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
      end,
      desc = "上一个函数",
    },
    {
      "<leader>ja",
      function()
        require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
      end,
      desc = "与下一个参数交换",
    },
    {
      "<leader>jA",
      function()
        require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.inner"
      end,
      desc = "与上一个参数交换",
    },
  },
}
