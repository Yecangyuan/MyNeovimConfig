-- This Lua script configures the GitHub Copilot plugin for Neovim.
-- It specifies when the plugin should be loaded, key mappings for interacting with Copilot,
-- and various settings for suggestions and the suggestion panel.

return {
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    event = { "InsertEnter" }, -- Load the plugin when entering insert mode.
    cmd = { "Copilot" }, -- The plugin can also be manually triggered with the Copilot command.
    opts = {
      suggestion = {
        auto_trigger = true, -- Automatically trigger suggestions.
      },
    },
    keys = {
      {
        mode = { "i" },
        "<A-c>",
        function()
          require("copilot.suggestion").accept_line() -- Accept the current line suggestion.
        end,
      },
      { mode = { "n" }, "<leader>Tc", "<CMD>Copilot enable<CR>", desc = "Copilot - Enable" }, -- Enable Copilot.
      { mode = { "n" }, "<leader>TC", "<CMD>Copilot disable<CR>", desc = "Copilot - Disable" }, -- Disable Copilot.
    },
    config = function()
      require("copilot").setup {
        panel = {
          enabled = true, -- Enable the suggestion panel.
          auto_refresh = false, -- Disable auto-refresh for the panel.
          keymap = {
            jump_prev = "[[", -- Key mapping to jump to the previous suggestion.
            jump_next = "]]", -- Key mapping to jump to the next suggestion.
            accept = "<M-CR>", -- Key mapping to accept the suggestion.
            refresh = "gr", -- Key mapping to refresh the panel.
            open = "<M-CR>", -- Key mapping to open the panel.
          },
          layout = {
            position = "bottom", -- Position the panel at the bottom.
            ratio = 0.4, -- Set the panel height ratio.
          },
        },
        suggestion = {
          enabled = true, -- Enable suggestions.
          auto_trigger = true, -- Automatically trigger suggestions.
          debounce = 75, -- Set debounce time for suggestions.
          keymap = {
            accept = "<Tab>", -- Key mapping to accept the suggestion.
            accept_word = false, -- Disable accepting a single word.
            accept_line = false, -- Disable accepting a single line.
            next = "<M-]>", -- Key mapping to navigate to the next suggestion.
            prev = "<M-[>", -- Key mapping to navigate to the previous suggestion.
            dismiss = "<C-]>", -- Key mapping to dismiss the suggestion.
          },
        },
        filetypes = {
          lua = true, -- Enable Copilot for Lua files.
          yaml = false, -- Disable Copilot for YAML files.
          markdown = false, -- Disable Copilot for Markdown files.
          help = false, -- Disable Copilot for help files.
          gitcommit = false, -- Disable Copilot for git commit messages.
          gitrebase = false, -- Disable Copilot for git rebase messages.
          hgcommit = false, -- Disable Copilot for Mercurial commit messages.
          svn = false, -- Disable Copilot for SVN commit messages.
          cvs = false, -- Disable Copilot for CVS commit messages.
          ["."] = false, -- Disable Copilot for hidden files.
        },
        copilot_node_command = "node", -- Node.js version must be > 18.x
        server_opts_overrides = {}, -- Reserved for server-specific overrides.
      }
    end,
  },
}
