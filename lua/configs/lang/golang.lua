return {
  "ray-x/go.nvim",
  dependencies = {
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "go", "gomod" },
  -- event = { "CmdlineEnter" },
  build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  config = function()
    local on_attach = require("override.lspconfig").on_attach

    require("go").setup {
      lsp_cfg = false,
      lsp_on_attach = nil,
      lsp_codelens = true,
      lsp_inlay_hints = {
        enable = true,
        -- hint style, set to 'eol' for end-of-line hints, 'inlay' for inline hints
        -- inlay only avalible for 0.10.x
        style = "inlay",
        -- Note: following setup only works for style = 'eol', you do not need to set it for 'inlay'
        -- Only show inlay hints for the current line
        only_current_line = false,
        -- Event which triggers a refersh of the inlay hints.
        -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
        -- not that this may cause higher CPU usage.
        -- This option is only respected when only_current_line and
        -- autoSetHints both are true.
        only_current_line_autocmd = "CursorHold",
        -- whether to show variable name before type hints with the inlay hints or not
        -- default: false
        show_variable_name = true,
        -- prefix for parameter hints
        parameter_hints_prefix = "󰊕 ",
        show_parameter_hints = true,
        -- prefix for all the other hints (type, chaining)
        other_hints_prefix = "=> ",
        -- whether to align to the lenght of the longest line in the file
        max_len_align = false,
        -- padding from the left if max_len_align is true
        max_len_align_padding = 1,
        -- whether to align to the extreme right or not
        right_align = false,
        -- padding from the right if right_align is true
        right_align_padding = 6,
        -- The color of the hints
        highlight = "Comment",
      },
      floaterm = { -- position
        posititon = "auto", -- one of {`top`, `bottom`, `left`, `right`, `center`, `auto`}
        width = 0.45, -- width of float window if not auto
        height = 0.98, -- height of float window if not auto
        title_colors = "tokyo", -- default to nord, one of {'nord', 'tokyo', 'dracula', 'rainbow', 'solarized ', 'monokai'}
        -- can also set to a list of colors to define colors to choose from
        -- e.g {'#D8DEE9', '#5E81AC', '#88C0D0', '#EBCB8B', '#A3BE8C', '#B48EAD'}
      },
      trouble = not vim.g.turbo_mode and require("settings").ui.trouble,
      test_efm = false, -- errorfomat for quickfix, default mix mode, set to true will be efm only
      luasnip = true, -- enable included luasnip snippets
    }
  end,
}
