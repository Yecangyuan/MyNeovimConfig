-- nvim-tree 极速优化配置
-- 禁用所有动画和实时更新功能

local options = {
  filters = {
    dotfiles = false,
    exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
  },
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = false,              -- ❌ 禁用光标劫持
  hijack_unnamed_buffer_when_opening = false,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = false,                   -- ❌ 禁用自动更新焦点文件（减少计算）
    update_root = false,
  },
  view = {
    adaptive_size = false,
    side = "left",
    width = 30,
    preserve_window_proportions = true,
  },
  git = {
    enable = true,
    ignore = false,
    show_on_dirs = true,
    show_on_open_dirs = false,        -- ❌ 只在展开时显示 git 状态
    timeout = 200,                    -- 减少 git 超时
  },
  filesystem_watchers = {
    enable = false,                   -- ❌ 禁用文件系统监视（性能杀手）
  },
  actions = {
    open_file = {
      resize_window = false,
      quit_on_open = false,
    },
  },
  renderer = {
    highlight_git = false,            -- ❌ 禁用 git 高亮
    highlight_opened_files = "none",  -- ❌ 禁用打开文件高亮
    root_folder_label = false,
    indent_markers = {
      enable = false,                 -- ❌ 禁用缩进标记
    },
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = false,                  -- ❌ 禁用 git 图标
      },
    },
  },
}

return options
