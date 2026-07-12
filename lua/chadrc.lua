vim.filetype.add {
  pattern = { [".*.conf"] = "hyprlang" },
}
vim.filetype.add {
  pattern = { [".*/hyprland%.conf"] = "hypr" },
}

require "autocmds"

if vim.g.neovide then
  require "neovide"
end

local function extract_time(text)
  return text:match("([%d:]+)$") or ""
end

local M = {}

M.ui = {
  theme = "tokyonight",
  theme_toggle = { "tokyonight", "tokyonight" },

  cmp = {
    style = "atom_colored", -- flatt_dark | flat_light | default | atom | atom_colored
    selected_item_bg = "colored",
  },

  tabufline = {
    order = { "buffers", "tabs" },
  },

  statusline = {
    theme = "default", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "default",

    modules = {
      pomo = function()
        local icon = "󰄉 "
        local ok, pomo = pcall(require, "pomo")
        if not ok then
          return ""
        end
        local timer = pomo.get_first_to_finish()
        if not timer then
          return ""
        end
        local text = tostring(timer)
        local time = extract_time(text)
        return "%#St_Lsp#" .. " " .. icon .. time .. " "
      end,
    },

    order = { "mode", "file", "git", "%=", "pomo", "cwd", "cursor" },
  },

  nvdash = {
    load_on_startup = true,

    header = {
      -- "           ▄ ▄                   ",
      -- "       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ",
      -- "       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ",
      -- "    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ",
      -- "  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ",
      -- "  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄",
      -- "▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █",
      -- "█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █",
      -- "    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    ",
      "                                                                     ",
      "                                                                   ",
      "      ████ ██████           █████      ██                    ",
      "     ███████████             █████                            ",
      "     █████████ ███████████████████ ███   ███████████  ",
      "    █████████  ███    █████████████ █████ ██████████████  ",
      "   █████████ ██████████ █████████ █████ █████ ████ █████  ",
      " ███████████ ███    ███ █████████ █████ █████ ████ █████ ",
      "██████  █████████████████████ ████ █████ █████ ████ ██████",
      "                                                                     ",
    },

    buttons = {
      {
        "󰁯  Restore Session",
        "Spc q s",
        "SessionManager load_last_session",
      },
      {
        "󱔘  Pick Session",
        "Spc q p",
        "SessionManager load_session",
      },
      {
        "  Zoxide",
        "Spc z x",
        "FzfLua zoxide",
      },
      {
        "  Find File",
        "Spc f",
        "FzfLua files",
      },
      {
        "󰈚  Recent Files",
        "Spc s o",
        "FzfLua oldfiles",
      },
      {
        "  Bookmarks",
        "Spc s m",
        "FzfLua marks",
      },
    },
  },

  lsp = {
    -- show function signatures i.e args as you type
    signature = false,
    semantic_tokens = false,
  },

  term = {
    -- hl = "Normal:term,WinSeparator:WinSeparator",
    sizes = { sp = 0.3, vsp = 0.2 },
    float = {
      relative = "editor",
      row = 0.1,
      col = 0.1,
      width = 0.8,
      height = 0.7,
      border = "single",
    },
  },

  hl_add = {
    FoldColumnLine = { fg = "grey", bg = "black" },
    FoldColumnSymbol = { fg = "grey_fg", bg = "black" },
    CursorLineFold = { fg = { "blue", 2 }, bg = "black" },
    DiagnosticError = { fg = "red", bg = "black" },
    DiagnosticWarn = { fg = "orange", bg = "black" },
    DiagnosticInfo = { fg = "blue", bg = "black" },
    DiagnosticHint = { fg = "green", bg = "black" },
    Identifier = { fg = "purple", bg = "black" },
  },

  hl_override = {
    FoldColumn = { fg = "grey", bg = "black" },
    Folded = {
      fg = "light_grey",
      bg = "black2",
    },
    NvDashAscii = {
      fg = "blue",
      bg = "black",
    },

    NvDashButtons = {
      fg = "white",
      bg = "black",
    },
  },
}

return M
