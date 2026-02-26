pcall(function()
  dofile(vim.g.base46_cache .. "syntax")
  dofile(vim.g.base46_cache .. "treesitter")
end)

local options = {
  ensure_installed = { "lua", "luadoc", "printf", "vim", "vimdoc", "java" },

  highlight = {
    enable = true,
    use_languagetree = true,
    -- 性能优化：大文件禁用高亮
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
      -- 超过 1000 行的文件也禁用
      local lines = vim.api.nvim_buf_line_count(buf)
      if lines > 1000 then
        return true
      end
      return false
    end,
    -- 减少解析范围以提高性能
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
    -- 大文件禁用缩进检测
    disable = function(lang, buf)
      local lines = vim.api.nvim_buf_line_count(buf)
      return lines > 1000
    end,
  },

  -- 性能优化：减少解析范围
  sync_install = false,
  auto_install = false,
  ignore_install = {},

  -- 增量解析
  parser_install_dir = nil,
}

return options
