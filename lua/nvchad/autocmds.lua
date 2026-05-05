local autocmd = vim.api.nvim_create_autocmd

-- user event that loads after UIEnter + only if file buf is there
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("NvFilePost", { clear = true }),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

    if not vim.g.ui_entered and args.event == "UIEnter" then
      vim.g.ui_entered = true
    end

    if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
      vim.api.nvim_del_augroup_by_name "NvFilePost"

      vim.schedule(function()
        vim.api.nvim_exec_autocmds("FileType", {})

        if vim.g.editorconfig then
          require("editorconfig").config(args.buf)
        end
      end)
    end
  end,
})

-- Initialize and manage vim.t.bufs for tabufline
autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufEnter", "TabNewEntered" }, {
  group = vim.api.nvim_create_augroup("TabuflineBufManagement", { clear = true }),
  callback = function(args)
    if vim.t.bufs == nil then
      vim.t.bufs = {}
    end

    local bufnr = args.buf
    
    -- 验证缓冲区是否有效
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end
    
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
    local buflisted = vim.api.nvim_get_option_value("buflisted", { buf = bufnr })

    -- 只添加普通的、可列出的缓冲区
    if buflisted and (buftype == "" or buftype == "acwrite") and bufname ~= "" then
      -- 检查缓冲区是否已在列表中
      local exists = false
      for _, v in ipairs(vim.t.bufs) do
        if v == bufnr then
          exists = true
          break
        end
      end

      -- 如果缓冲区不存在，添加到列表
      if not exists then
        table.insert(vim.t.bufs, bufnr)
      end
    end
    
    -- 清理无效的缓冲区
    local valid_bufs = {}
    for _, buf_id in ipairs(vim.t.bufs) do
      if vim.api.nvim_buf_is_valid(buf_id) and vim.api.nvim_get_option_value("buflisted", { buf = buf_id }) then
        table.insert(valid_bufs, buf_id)
      end
    end
    vim.t.bufs = valid_bufs
  end,
})

-- Remove deleted buffers from vim.t.bufs
autocmd("BufDelete", {
  group = vim.api.nvim_create_augroup("TabuflineBufDelete", { clear = true }),
  callback = function(args)
    if vim.t.bufs then
      for i, v in ipairs(vim.t.bufs) do
        if v == args.buf then
          table.remove(vim.t.bufs, i)
          break
        end
      end
    end
  end,
})
