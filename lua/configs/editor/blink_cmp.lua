-- blink.cmp: 超快速的代码补全插件（Rust 编写）
-- 替代 nvim-cmp，性能更好，启动更快
return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    -- 可选：如果你想用 copilot 补全
    -- "giuxtaposition/blink-cmp-copilot",
  },
  lazy = false,
  version = "*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 按键映射: 'default' | 'super-tab' | 'enter'
    keymap = {
      preset = "default",
      -- 自定义按键
      -- Tab: 只在菜单可见时选择，否则直接插入 Tab
      ["<Tab>"] = {
        function(cmp)
          if cmp.is_menu_visible() then
            cmp.select_next()
            return true
          end
        end,
        "fallback", -- 直接 fallback 到插入 Tab
      },
      ["<S-Tab>"] = {
        function(cmp)
          if cmp.is_menu_visible() then
            cmp.select_prev()
            return true
          end
        end,
        "fallback",
      },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
      kind_icons = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "󰒓",
        Field = "󰜢",
        Variable = "󰀫",
        Property = "󰖷",
        Class = "󰠱",
        Interface = "󰕘",
        Struct = "󰠱",
        Module = "󰏗",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "󰕘",
        EnumMember = "󰕘",
        Keyword = "󰌋",
        Constant = "󰏿",
        Snippet = "󰩫",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        Event = "󰉒",
        Operator = "󰆕",
        TypeParameter = "󰊄",
        Copilot = "",
      },
    },

    -- 补全行为
    completion = {
      -- ❌ 禁用文档自动显示（解决焦点跳转问题）
      documentation = {
        auto_show = false,
        -- 手动按 C-space 才显示
      },
      -- 菜单外观
      menu = {
        auto_show = true,
        border = "rounded",
        draw = {
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
          treesitter = { "lsp" },
        },
      },
      -- 列表限制
      list = {
        max_items = 200,
      },
      -- 幽灵文本
      ghost_text = {
        enabled = false,
      },
      -- 触发设置
      trigger = {
        show_in_snippet = false,  -- 在 snippet 中不显示补全
        show_on_keyword = true,
        show_on_trigger_character = true,
        -- ❌ 禁用空格触发补全
        show_on_blocked_trigger_characters = { " ", "\n", "\t" },
      },
    },

    -- 签名帮助
    signature = {
      enabled = true,
      window = {
        border = "rounded",
        show_documentation = false, -- 禁用签名文档避免焦点问题
      },
    },

    -- 补全来源
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      -- 如果需要 copilot，取消下面注释并添加 "copilot"
      -- default = { "lsp", "path", "snippets", "buffer", "copilot" },
      providers = {
        -- copilot = {
        --   name = "copilot",
        --   module = "blink-cmp-copilot",
        --   score_offset = 100,
        --   async = true,
        -- },
      },
    },

    -- 模糊匹配算法
    fuzzy = {
      implementation = "prefer_rust_with_warning",
      max_typos = function(keyword) return math.floor(#keyword / 4) end,
      use_proximity = true,
      sorts = { "score", "sort_text" },
    },
  },

  opts_extend = { "sources.default" },
}
