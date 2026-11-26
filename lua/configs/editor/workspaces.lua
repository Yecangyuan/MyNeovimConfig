return {
  "natecraddock/workspaces.nvim",
  cmd = {
    "WorkspacesAdd",
    "WorkspacesAddDir",
    "WorkspacesRemove",
    "WorkspacesRemoveDir",
    "WorkspacesRename",
    "WorkspacesList",
    "WorkspacesListDirs",
    "WorkspacesOpen",
    "WorkspacesSyncDirs",
  },
  keys = {
    { "<leader>wo", "<cmd>WorkspacesOpen<CR>", desc = "Workspaces - Open" },
  },
  opts = {
    path = vim.fn.stdpath "data" .. "/workspaces",
    cd_type = "global",
    mru_sort = true,
    auto_open = false,
  },
}
