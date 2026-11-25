return function(dap)
  local adapter = { type = "executable", command = "lldb-dap" }
  if vim.fn.executable "lldb-dap" == 0 and vim.fn.has "mac" == 1 then
    adapter.command = "xcrun"
    adapter.args = { "lldb-dap" }
  end
  dap.adapters["lldb-dap"] = adapter

  local compiling = false
  dap.configurations.c = {
    {
      name = "编译并调试当前 C 文件",
      type = "lldb-dap",
      request = "launch",
      cwd = "${fileDirname}",
      program = function()
        local source = vim.api.nvim_buf_get_name(0)
        if vim.bo.modified or vim.fn.fnamemodify(source, ":e") ~= "c" or vim.fn.filereadable(source) == 0 then
          vim.notify("请先保存要调试的 .c 文件", vim.log.levels.WARN)
          return dap.ABORT
        end
        if vim.fn.executable "clang" == 0 then
          vim.notify("找不到 clang，无法编译 C 文件", vim.log.levels.ERROR)
          return dap.ABORT
        end
        if compiling then
          return dap.ABORT
        end

        compiling = true
        local program = vim.fn.tempname()
        return coroutine.create(function(dap_run)
          local command = { "clang", "-g", "-O0", source, "-o", program }
          local on_exit = vim.schedule_wrap(function(result)
            compiling = false
            if result.code ~= 0 then
              vim.notify(result.stderr, vim.log.levels.ERROR, { title = "C 编译失败" })
              coroutine.resume(dap_run, dap.ABORT)
              return
            end
            coroutine.resume(dap_run, program)
          end)
          local ok, err = pcall(vim.system, command, { text = true }, on_exit)
          if not ok then
            compiling = false
            vim.notify(tostring(err), vim.log.levels.ERROR, { title = "无法启动 clang" })
            coroutine.resume(dap_run, dap.ABORT)
          end
        end)
      end,
    },
  }
end
