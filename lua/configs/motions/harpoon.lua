return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  config = function()
    require("harpoon").setup {
      global_settings = {
        -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
        save_on_toggle = false,
        save_on_change = true,
        enter_on_sendcmd = false,
        -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
        tmux_autoclose_windows = false,
        -- filetypes that you want to prevent from adding to the harpoon list menu.
        excluded_filetypes = { "harpoon" },
        -- set marks specific to each git branch inside git repository
        mark_branch = false,
      },
    }
    local harpoon = require "harpoon"
    harpoon:setup()

    vim.keymap.set("n", "<leader>ha", function()
      harpoon:list():append()
    end, { desc = "Harpoon - Add" })
    vim.keymap.set("n", "<leader>hl", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon - List" })

    vim.keymap.set("n", "<A-P>", function()
      harpoon:list():prev()
    end, { desc = "Harpoon - Previous" })
    vim.keymap.set("n", "<A-N>", function()
      harpoon:list():next()
    end, { desc = "Harpoon - Next" })

    vim.keymap.set("n", "<leader>h1", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon - 1" })
    vim.keymap.set("n", "<leader>h2", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon - 2" })
    vim.keymap.set("n", "<leader>h3", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon - 3" })
    vim.keymap.set("n", "<leader>h4", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon - 4" })
    vim.keymap.set("n", "<leader>h5", function()
      harpoon:list():select(5)
    end, { desc = "Harpoon - 5" })
    vim.keymap.set("n", "<leader>h6", function()
      harpoon:list():select(6)
    end, { desc = "Harpoon - 6" })

    -- telescope 已禁用，移除了 telescope 集成
    -- 使用 <leader>hl 打开 harpoon 列表即可
  end,
}
