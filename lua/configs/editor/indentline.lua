-- indent-blankline 性能优化配置
-- 覆盖 NvChad 的默认配置，减少光标移动延迟

return {
  "lukas-reineke/indent-blankline.nvim",
  event = "User FilePost",
  opts = {
    indent = {
      char = "│",
      highlight = "IblChar",
      -- 性能优化：智能缩进检测
      smart_indent_cap = true,
    },
    scope = {
      char = "│",
      highlight = "IblScopeChar",
      enabled = true,
      -- 性能优化：减少 scope 计算
      show_start = false,
      show_end = false,
      injected_languages = false,
      priority = 500,
    },
    -- 性能优化：排除大文件
    exclude = {
      filetypes = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
        "lspinfo",
        "checkhealth",
        "man",
        "gitcommit",
        "TelescopePrompt",
        "",
      },
      buftypes = { "terminal", "nofile", "quickfix", "prompt" },
    },
    -- 性能优化：减少重绘
    viewport_buffer = {
      min = 30,
      max = 500,
    },
  },
  config = function(_, opts)
    dofile(vim.g.base46_cache .. "blankline")

    local hooks = require "ibl.hooks"
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

    -- 大文件检测：禁用 indentline
    local ok, ibl = pcall(require, "ibl")
    if ok then
      -- 创建大文件检测自动命令
      vim.api.nvim_create_autocmd("BufRead", {
        pattern = "*",
        callback = function(args)
          local bufnr = args.buf
          local lines = vim.api.nvim_buf_line_count(bufnr)

          if lines > 3000 then
            vim.b[bufnr].disable_indentline = true
            return
          end

          ibl.setup(opts)
        end,
        once = true,
      })

      -- 正常设置
      ibl.setup(opts)
    end

    dofile(vim.g.base46_cache .. "blankline")
  end,
}
