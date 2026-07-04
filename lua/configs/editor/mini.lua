return {
  "echasnovski/mini.nvim",
  version = "*",
  event = "BufRead",
  config = function()
    require("mini.indentscope").setup {
      draw = {
        delay = 100,  -- 增加延迟，减少光标移动时的计算
        animation = require("mini.indentscope").gen_animation.none(),  -- 禁用动画
      },
      mappings = {
        -- Textobjects
        object_scope = "ii",
        object_scope_with_border = "ai",
        -- Motions (jump to respective border line; if not present - body line)
        goto_top = "[i",
        goto_bottom = "]i",
      },
      -- Which character to use for drawing scope indicator
      symbol = "│",
      -- 禁用在某些文件类型上
      options = {
        try_as_border = true,
      },
    }
    require("mini.surround").setup {
      -- 改用 gz 前缀，避免 mini.surround 把原生 s（替换字符）映射成 <Nop>
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "gzr", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`

        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
      -- Whether to respect selection type:
      -- - Place surroundings on separate lines in linewise mode.
      -- - Place surroundings on each line in blockwise mode.
      respect_selection_type = false,
    }
    require("mini.align").setup {
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        start = "ga",
        start_with_preview = "gA",
      },
      -- Default steps performing alignment (if `nil`, default is used)
      steps = {
        pre_split = {},
        split = nil,
        pre_justify = {},
        justify = nil,
        pre_merge = {},
        merge = nil,
      },
    }
    -- 替代 illuminate.nvim：高亮当前光标下的单词
    require("mini.cursorword").setup {
      delay = 200,  -- 增加延迟，避免频繁重绘
    }
  end,
}
