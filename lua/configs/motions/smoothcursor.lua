return {
  "gen740/smoothcursor.nvim",
  event = "VeryLazy",
  config = function()
    require("smoothcursor").setup({
      type = "default",     -- 光标样式: default, exp (exponential), beep, matrix
      cursor = "",          -- 使用的cursor图标
      texthl = "SmoothCursor", -- 高亮组
      linehl = nil,         -- 光标线高亮
      
      -- 速度和抖动配置
      speed = 25,           -- 速度 (1-100)
      intervals = 35,       -- 更新间隔
      priority = 10,        -- 渲染优先级
      timeout = 3000,       -- 超时时间
      threshold = 3,        -- 抖动阈值
      
      -- 禁用的filetypes和buftypes
      disabled_filetypes = {
        "TelescopePrompt",
        "neo-tree",
        "neo-tree-popup",
        "NvimTree",
        "alpha",
        "lazy",
        "DressingInput",
        "notify",
        "mason",
      },
      
      -- 抖动配置 (类似打字机效果)
      flyin_effect = nil,    -- 飞入效果: nil, top, bottom, left, right
      autostart = true,      -- 自动启动
      
      -- 可选：不同模式的不同颜色
      modes = {
        n = {
          patterns = { { fg = "#89b4fa" } }, -- 普通模式颜色
          cursor = "",
          linehl = nil,
        },
        i = {
          patterns = { { fg = "#f38ba8" } }, -- 插入模式颜色
          cursor = "",
          linehl = nil,
        },
        v = {
          patterns = { { fg = "#a6e3a1" } }, -- 可视模式颜色
        },
      },
    })
  end,
} 