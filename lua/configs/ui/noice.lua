local settings = require "settings"
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- lazy = true,
    {
      "rcarriga/nvim-notify",
      -- lazy = true,
      -- config = function()
      --   dofile(vim.g.base47_cache .. "notify")
      -- end,
    },
  },
  config = function()
    require("noice").setup {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        format = {
          -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
          -- view: (default is cmdline view)
          -- opts: any options passed to the view
          -- icon_hl_group: optional hl_group for the icon
          -- title: set to anything or empty string to hide
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
          filter = { pattern = "^:%s*!", icon = "󰻿 ", lang = "bash" },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
          input = {}, -- Used by input()
          -- lua = false, -- to disable a format, set to `false`
        },
      },
      messages = {
        enabled = false, -- enables the Noice messages UI
      },
      popupmenu = {
        enabled = true, -- enables the Noice popupmenu UI
        ---@type 'nui'|'cmp'
        backend = "nui", -- backend to use to show regular cmdline completions
        ---@type NoicePopupmenuItemKind|false
        -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
        kind_icons = {}, -- set to `false` to disable icons
      },
      notify = {
        -- Noice can be used as `vim.notify` so you can route any notification like other messages
        -- Notification messages have their level and other properties set.
        -- event is always "notify" and kind can be any log level as a string
        -- The default routes will forward notifications to nvim-notify
        -- Benefit of using Noice for this is the routing and consistent history view
        enabled = settings.ui.notify,
        view = "notify",
      },
      lsp = {
        progress = {
          enabled = false,
          -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
          -- See the section on formatting for more details on how to customize.
          --- @type NoiceFormat|string
          format = "lsp_progress",
          --- @type NoiceFormat|string
          format_done = "lsp_progress_done",
          throttle = 1001 / 30, -- frequency to update lsp progress message
          view = "mini",
        },
        hover = {
          enabled = true,
        },
        signature = {
          enabled = true,
        },
        message = {
          -- Messages shown by lsp servers
          enabled = false,
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      health = {
        checker = false, -- Disable if you don't want health checks to run
      },
      routes = {
        -- {
        --   filter = {
        --     event = "lsp",
        --     any = {
        --       { find = "formatting" },
        --       { find = "Diagnosing" },
        --       { find = "Diagnostics" },
        --       { find = "diagnostics" },
        --       { find = "code_action" },
        --       { find = "Processing full semantic tokens" },
        --       { find = "symbols" },
        --       { find = "completion" },
        --     },
        --   },
        --   opts = { skip = true },
        -- },
        {
          filter = {
            event = "notify",
            any = {
              -- Telescope
              { find = "Nothing currently selected" },
              { find = "^No information available$" },
              { find = "Highlight group" },
              { find = "no manual entry for" },
              { find = "not have parser for" },

              -- ts
              { find = "_ts_parse_query" },
            },
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "",
            any = {

              -- Edit
              { find = "%d+ less lines" },
              { find = "%d+ fewer lines" },
              { find = "%d+ more lines" },
              { find = "%d+ change;" },
              { find = "%d+ line less;" },
              { find = "%d+ more lines?;" },
              { find = "%d+ fewer lines;?" },
              { find = '".+" %d+L, %d+B' },
              { find = "%d+ lines yanked" },
              { find = "^Hunk %d+ of %d+$" },
              { find = "%d+L, %d+B$" },

              -- Save
              { find = " bytes written" },

              -- Redo/Undo
              { find = " changes; before #" },
              { find = " changes; after #" },
              { find = "2 change; before #" },
              { find = "2 change; after #" },

              -- File Opts
              -- { find = "Created" }, -- 过滤创建文件的通知
              -- { find = "Deleted" }, -- 过滤删除文件的通知
              -- { find = "created" },
              -- { find = "deleted" },

              -- Yank
              { find = " lines yanked" },

              -- Move lines
              { find = " lines moved" },
              { find = " lines indented" },

              -- Bulk edit
              { find = " fewer lines" },
              { find = " more lines" },
              { find = "2 more line" },
              { find = "2 line less" },

              -- General messages
              { find = "Already at newest change" },
              { find = "Already at oldest change" },
              { find = "E22: Cannot make changes, 'modifiable' is off" },
            },
          },
          opts = { skip = true },
        },
      },

      views = {
        cmdline_popup = {
          position = {
            row = 4,
            col = "51%",
          },
          size = {
            width = 61,
            height = "auto",
          },
        },
        popupmenu = {
          relative = "editor",
          position = {
            row = 9,
            col = "51%",
          },
          size = {
            width = 61,
            height = 11,
          },
          border = {
            style = "rounded",
            padding = { 1, 1 },
          },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          },
        },
        mini = {
          zindex = 101,
          win_options = { winblend = 1 },
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        lsp_doc_border = false, -- add a border to hover docs and signature help
        inc_rename = settings.editor.inc_rename,
      },
    }

    vim.keymap.set("n", "<leader>nd", "<cmd> NoiceDismiss <CR>", { desc = "Noice - Dismiss Notifications" })
  end,
}
