dofile(vim.g.base46_cache .. "nvimtree")

local options = {
  filters = { dotfiles = true },
  disable_netrw = true,
  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  view = {
    width = 30,
    preserve_window_proportions = true,
  },
  renderer = {
    root_folder_label = false,
    highlight_git = true,
    indent_markers = { enable = true },
    icons = {
      glyphs = {
        default = "󰈚",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
        },
        git = { unmerged = "" },
      },
    },
  },
  -- 新增的通知配置
  notify = {
    threshold = vim.log.levels.WARN, -- 只显示 WARN 级别以上的通知，过滤掉创建、删除文件的通知
  },
}

return options
