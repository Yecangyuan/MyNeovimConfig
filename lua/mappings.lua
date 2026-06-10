require "nvchad.mappings"
local settings = require "settings"
local map = vim.keymap.set
local nomap = vim.keymap.del
local o = vim.opt

map("i", "jk", "<ESC>")

map({ "n" }, "<leader>qq", "<CMD>ccl<CR>", { desc = "Quickfix - Close all" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- ── Buffer ────────────────────────────────────────────────────
map("n", "<leader>nb", "<cmd> new <CR>", { desc = "Buffer - New" })
map("n", "<leader>bd", "<cmd> q <CR>", { desc = "Buffer - Close" })

map("n", "<leader>bk", function()
  local ok, tabufline = pcall(require, "nvchad.tabufline")
  if ok and tabufline and tabufline.close_buffer then
    tabufline.close_buffer()
  end
end, { desc = "Buffer - Close" })

map("n", "<leader>bo", function()
  local ok, tabufline = pcall(require, "nvchad.tabufline")
  if ok and tabufline and tabufline.closeOtherBufs then
    tabufline.closeOtherBufs()
  end
end, { desc = "Buffer - Close others" })

map("n", "<leader>bh", function()
  local ok, tabufline = pcall(require, "nvchad.tabufline")
  if ok and tabufline and tabufline.move_buf then
    tabufline.move_buf(2)
  end
end, { desc = "Buffer - Move left" })

map("n", "<leader>bl", function()
  local ok, tabufline = pcall(require, "nvchad.tabufline")
  if ok and tabufline and tabufline.move_buf then
    tabufline.move_buf(4)
  end
end, { desc = "Buffer - Move right" })

map("n", "<S-L>", function()
  -- 确保 vim.t.bufs 存在并且不为空
  if vim.t.bufs and #vim.t.bufs > 0 then
    require("nvchad.tabufline").next()
  else
    -- 如果没有缓冲区列表，使用原生的 :bnext
    vim.cmd("bnext")
  end
end, { desc = "Buffer - Goto next" })

map("n", "<S-H>", function()
  local ok, tabufline = pcall(require, "nvchad.tabufline")
  if ok and tabufline and tabufline.prev then
    tabufline.prev()
  end
end, { desc = "Buffer - Goto previous" })

-- ── Code ──────────────────────────────────────────────────────
map("v", "<leader>ca", function()
  vim.lsp.buf.code_action()
end, { desc = "Code Action" })
map("n", "<leader>ca", function()
  vim.lsp.buf.code_action()
end, { desc = "Code Action" })

if settings.editor.inc_rename then
  map("n", "<leader>cr", ":IncRename ", { desc = "IncRename" })
else
  map("n", "<leader>cr", function()
    vim.lsp.buf.rename()
  end, { desc = "LSP rename" })
end

map("n", "<leader>cd", function()
  vim.diagnostic.open_float { border = "rounded" }
end, { desc = "Diagnostic - Open float" })

-- 如需 Code Action Preview，请安装 actions-preview.nvim 插件
-- map("n", "<leader>cp", function()
--   require("actions-preview").code_actions()
-- end, { desc = "Code Action Preview" })

-- ── Dashboard ─────────────────────────────────────────────────
map("n", "<leader>;", function()
  require("nvchad.dashboard").open()
end, { desc = "Dashboard" })

-- ── Lazy ──────────────────────────────────────────────────────
map("n", "<leader>pl", ":Lazy<CR>", { desc = "Lazy - Open Plugin Manager" })

-- ── mason ─────────────────────────────────────────────────────
map("n", "<leader>om", ":Mason<CR>", { desc = "Mason" })

-- ── NvimTree ──────────────────────────────────────────────────
map("n", "<leader>e", "<cmd> NvimTreeToggle <CR>", { desc = "NvimTree - Toggle" })

-- ── Term ──────────────────────────────────────────────────────
map({ "n", "t" }, "<A1>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "floatTerm", size = 3.3 }
end)
map({ "n", "t" }, "<A2>", function()
  require("nvchad.term").toggle { pos = "sp", id = "floatTerm", size = 3.3 }
end)
map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end)

-- ── FzfLua ─────────────────────────────────────────────────
-- 所有 fzf-lua 快捷键已在 lua/configs/editor/fzf.lua 中定义
-- 以下是额外或覆盖的映射

-- 使用 FzfLua 替代 Telescope 的命令
map("n", "<leader>sc", ":FzfLua builtin<CR>", { desc = "Fzf - Editor Commands" })
map("n", "<leader>st", ":FzfLua<CR>", { desc = "Fzf - All Commands" })
map("n", "<leader>sa", "<cmd>FzfLua files follow=true no_ignore=true hidden=true<CR>", { desc = "Fzf - Find all files" })

map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>b", "<cmd>FzfLua buffers<cr>", { desc = "List buffers" })

-- Buffer 切换
map("n", "<leader>bn", function()
  require("nvchad.tabufline").next()
end, { desc = "Buffer goto next" })

map("n", "<leader>bp", function()
  require("nvchad.tabufline").prev()
end, { desc = "Buffer goto prev" })

-- ── Toggle ────────────────────────────────────────────────────
local toggled = false
map("n", "<leader>Ta", function()
  vim.opt.concealcursor = "nc"
  if toggled then
    vim.opt.conceallevel = 3
    toggled = false
  else
    vim.opt.conceallevel = 3
    toggled = true
  end
end, { desc = "Toggle Conceal" })
map("n", "<leader>Tnl", "<cmd> set nu! <CR>", { desc = "Toggle - Line Number" })
map("n", "<leader>Tnr", "<cmd> set rnu! <CR>", { desc = "Toggle - Relative Number" })
map("n", "<leader>TD", function()
  require("gitsigns").toggle_deleted()
end, { desc = "GitSigns - Toggle deleted" })
map("n", "<leader>Th", "<cmd>FzfLua colorschemes<CR>", { desc = "Fzf - Themes" })
map("n", "<leader>Ts", function()
  require("base46").toggle_transparency()
end, { desc = "Nvchad - Toggle Transparency" })

-- ── Window ────────────────────────────────────────────────────

map("n", "<leader>|", "<CMD>vs <CR>", { desc = "Split - Vertical" })
map("n", "<leader>-", "<CMD>sp <CR>", { desc = "Split - Horizontal" })

-- Comment
map("n", "<C-/>", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Comment - Toggle" })

map(
  "v",
  "<C-/>",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "Comment - Toggle" }
)

-- ── Term ──────────────────────────────────────────────────────
map("n", "<leader>t", "<cmd>split | terminal<CR>", { desc = "Open terminal" })
-- Terminal 模式下 <esc> 的映射由 TermOpen autocmd 设置（见下方）

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "Whichkey - all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "Whichkey - query lookup" })

-- toggleterm
local function set_terminal_keymaps()
  local topts = { noremap = true }

  map("t", "<esc>", [[<C-\><C-n>]], topts)
  map("t", "jk", [[<C-\><C-n>]], topts)
  map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], topts)
  map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], topts)
  map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], topts)
  map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], topts)
  map("t", "<C-w>", [[<C-\><C-n><C-w>]], topts)
end

map("n", "<leader>+", "<C-a>", { desc = "Increment number" })
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" })
map("n", "<leader>dw", 'vb"_d', { desc = "Delete word backward" })
map("n", "<leader>all", "gg<S-v>G", { desc = "Select all" })
-- ss/sv 会导致 s 键延迟，改用 <leader>- 和 <leader>|
-- map("n", "ss", ":split<Return>", { noremap = true })
-- map("n", "sv", ":vsplit<Return>", { noremap = true })

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = set_terminal_keymaps,
})

nomap("n", "<leader>cc")
nomap("n", "gr")

o.jumpoptions = "stack"
