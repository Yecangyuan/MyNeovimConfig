require "nvchad.mappings"
local settings = require "settings"
local map = vim.keymap.set
local nomap = vim.keymap.del
local o = vim.opt

-- ── unmap ─────────────────────────────────────────────────────
-- nomap("t", "<A-h>")
-- nomap("t", "<A-v>")
--
-- nomap("n", "<leader>lf")
-- nomap("n", "<leader>q")
-- nomap("n", "<A-h>")
-- nomap("n", "<A-v>")
-- nomap("n", "<leader>h")
-- nomap("n", "<leader>v")
-- nomap("n", "<leader>sz")
-- nomap("n", "<leader>b")
-- nomap("n", "<C-n>")
-- nomap("n", "<leader>cm")
-- nomap("n", "<leader>n")
-- nomap("n", "<leader>pt")
-- nomap("n", "<leader>rn")
-- nomap("n", "<Tab>")
-- nomap("n", "<S-Tab>")
--
-- nomap("n", "<leader>fa")
-- nomap("n", "<leader>fb")
-- nomap("n", "<leader>ff")
-- nomap("n", "<leader>fh")
-- nomap("n", "<leader>fm")
-- nomap("n", "<leader>fo")
-- nomap("n", "<leader>fw")
-- nomap("n", "<leader>fz")
--
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

if settings.ui.inc_rename then
  map("n", "<leader>cr", ":IncRename ", { desc = "IncRename" })
else
  map("n", "<leader>cr", function()
    vim.lsp.buf.rename()
  end, { desc = "LSP rename" })
end

map("n", "<leader>cd", function()
  vim.diagnostic.open_float { border = "rounded" }
end, { desc = "Diagnostic - Open float" })

map("n", "<leader>cp", function()
  require("actions-preview").code_actions()
end, { desc = "Code Action Preview" })

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
map("n", "<leader>n", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>p", ":bprev<CR>", { desc = "Previous buffer" })
map("n", "<leader>b", "<cmd>FzfLua buffers<cr>", { desc = "List buffers" })

-- Jumplist navigation - 删除可能的冲突映射并重新设置
pcall(vim.keymap.del, "n", "<Tab>")
pcall(vim.keymap.del, "n", "<C-i>")

-- 重新设置正确的 jumplist 映射
map("n", "<C-o>", "<C-o>", { desc = "Go to previous jump" })
map("n", "<C-i>", "<C-i>", { desc = "Go to next jump" })

-- 为 buffer 切换使用不同的按键组合
map("n", "<leader>bn", function()
  require("nvchad.tabufline").next()
end, { desc = "Buffer goto next" })

map("n", "<leader>bp", function()
  require("nvchad.tabufline").prev()
end, { desc = "Buffer goto prev" })

-- 使用 Neovim 原生命令
-- map("n", "<leader>o", "g;", { desc = "Go to older position" })
-- map("n", "<leader>i", "g,", { desc = "Go to newer position" })

-- ── Toggle ────────────────────────────────────────────────────
local toggled = false
map("n", "<leader>Ta", function()
  vim.opt.concealcursor = "nc"
  if toggled then
    vim.opt.conceallevel = 3
    toggled = false
  else
    vim.opt.conceallevel = 5
    toggled = true
  end
end, { desc = "Toggle Conceal" })
map("n", "<leader>Tnl", "<cmd> set nu! <CR>", { desc = "Toggle - Line Number" })
map("n", "<leader>Tnr", "<cmd> set rnu! <CR>", { desc = "Toggle - Relative Number" })
map("n", "<leader>TD", function()
  require("gitsigns").toggle_deleted()
end, { desc = "GitSigns - Toggle deleted" })
map("n", "<leader>Th", "<cmd> Telescope themes <CR>", { desc = "Nvchad - Themes" })
map("n", "<leader>Ts", function()
  require("base49").toggle_transparency()
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
map("t", "<ESC>", function()
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_close(win, true)
end, { desc = "Terminal - Close term in terminal mode" })

map({ "n", "t" }, "<A1>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "floatTerm", size = 3.3 }
end)
map({ "n", "t" }, "<A2>", function()
  require("nvchad.term").toggle { pos = "sp", id = "floatTerm", size = 3.3 }
end)
map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end)

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "Whichkey - all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "Whichkey - query lookup" })

-- toggleterm
function _G.set_terminal_keymaps()
  local opts = { noremap = true }

  map("t", "<esc>", [[<C-\><C-n>]], opts)
  map("t", "jk", [[<C-\><C-n>]], opts)
  map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  map("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

-- Jumplist
-- map("n", "<C-m>", "<C-i>", opts)

-- Increment/decrement
map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

-- New tab
-- map("n", "te", ":tabedit")
-- map("n", "<tab>", ":tabnext<Return>", opts)
-- map("n", "<s-tab>", ":tabprev<Return>", opts)

-- Delete a word backwards
map("n", "dw", 'vb"_d')

-- Select all, comment this, becuase of keymap conflict
map("n", "<leader>all", "gg<S-v>G")

-- Split window
map("n", "ss", ":split<Return>", opts)
map("n", "sv", ":vsplit<Return>", opts)

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"

-- map(
--   "n",
--   "<leader>fr",
--   ':lua require("lua.configs.utility.findreplace").create_input_dialog()<CR>',
--   { noremap = true, silent = true }
-- )

nomap("n", "<leader>cc")
nomap("t", "<ESC>")
nomap("n", "gr")

-- 确保删除可能干扰 jumplist 的映射
pcall(nomap, "n", "<Tab>")
pcall(nomap, "n", "<C-i>")

-- 配置 jumplist 行为
o.jumpoptions = "stack"

-- vim.cmd [[
--   set tagfunc=v:lua.vim.lsp.tagfunc
--   set jumpoptions+=stack
-- ]]

-- nomap("n", "<C-j>", "<Cmd>normal! <C-o><CR>", { desc = "Jumplist 向后跳转" })
-- nomap("n", "<C-k>", "<Cmd>normal! <C-i><CR>", { desc = "Jumplist 向前跳转" })
-- 删除已有的 <C-j> 和 <C-k> 映射，确保按键可用
-- nomap("n", "<C-j>", { silent = true })
-- nomap("n", "<C-k>", { silent = true })
--
-- map("n", "<C-j>", "<Cmd>normal! <C-o><CR>", { desc = "Jumplist 向后跳转" })
-- map("n", "<C-k>", "<Cmd>normal! <C-i><CR>", { desc = "Jumplist 向前跳转" })
