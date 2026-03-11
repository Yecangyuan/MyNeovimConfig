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
      -- Tab: 只在菜单可见时选择，否则尝试 snippet，否则插入 Tab
      ["<Tab>"] = {
        function(cmp)
          if cmp.is_menu_visible() then
            cmp.select_next()
            return true
          end
        end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = {
        function(cmp)
          if cmp.is_menu_visible() then
            cmp.select_prev()
            return true
          end
        end,
        "snippet_backward",
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
      -- 自动显示文档
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
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
      -- 幽灵文本
      ghost_text = {
        enabled = false,
      },
      -- 触发设置
      trigger = {
        show_in_snippet = true,
        show_on_keyword = true,
        show_on_trigger_character = true,
      },
    },

    -- 签名帮助
    signature = {
      enabled = true,
      window = {
        border = "rounded",
        show_documentation = true,
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
      use_typo_resistance = true,
      use_proximity = true,
      max_items = 200,
    },
  },

  opts_extend = { "sources.default" },
}
