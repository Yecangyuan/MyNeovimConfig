require "nvchad.mappings"
local settings = require "settings"
local map = vim.keymap.set
local nomap = vim.keymap.del
local o = vim.opt

-- 恢复 <C-i> 跳转前进：NvChad 把 <Tab> 映射到 buffer next，但终端里 <Tab> 和 <C-i> 是同一个 keycode
nomap("n", "<tab>")

map("i", "jk", "<ESC>")

map({ "n" }, "<leader>qq", "<CMD>ccl<CR>", { desc = "Quickfix - Close all" })

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
  if vim.t.bufs and #vim.t.bufs > 0 then
    require("nvchad.tabufline").next()
  else
    vim.cmd "bnext"
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

map("n", "<leader>cf", function()
  local ok, conform = pcall(require, "conform")
  if ok then
    conform.format()
  end
end, { desc = "Conform - Format Buffer", noremap = true, silent = true })

-- ── Dashboard ─────────────────────────────────────────────────
map("n", "<leader>;", function()
  require("nvchad.dashboard").open()
end, { desc = "Dashboard" })

-- ── Lazy ──────────────────────────────────────────────────────
map("n", "<leader>pl", ":Lazy<CR>", { desc = "Lazy - Open Plugin Manager" })

-- ── mason ─────────────────────────────────────────────────────
map("n", "<leader>om", ":Mason<CR>", { desc = "Mason" })

-- ── NvimTree / Oil ────────────────────────────────────────────
map("n", "<leader>e", "<cmd> NvimTreeToggle <CR>", { desc = "NvimTree - Toggle" })
map("n", "<leader>oi", ":Oil<CR>", { desc = "Oil - Open" })
map("n", "<leader>of", function()
  local ok, oil = pcall(require, "oil")
  if ok then
    oil.toggle_float()
  end
end, { desc = "Oil - Open Float" })

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
map("n", "<leader>sc", ":FzfLua builtin<CR>", { desc = "Fzf - Editor Commands" })
map("n", "<leader>st", ":FzfLua<CR>", { desc = "Fzf - All Commands" })
map("n", "<leader>sa", "<cmd>FzfLua files follow=true no_ignore=true hidden=true<CR>", { desc = "Fzf - Find all files" })

map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>b", "<cmd>FzfLua buffers<cr>", { desc = "List buffers" })

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

-- ── Window / Workspaces ───────────────────────────────────────
map("n", "<leader>|", "<CMD>vs <CR>", { desc = "Split - Vertical" })
map("n", "<leader>-", "<CMD>sp <CR>", { desc = "Split - Horizontal" })
map("n", "<leader>wo", "<CMD>WorkspacesOpen<CR>", { desc = "Workspaces - List" })

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

-- ── Smart Splits ──────────────────────────────────────────────
map("n", "<C-h>", function()
  local ok, ss = pcall(require, "smart-splits")
  if ok then
    ss.move_cursor_left()
  end
end, { desc = "SmartSplits - Focus Left" })
map("n", "<C-j>", function()
  local ok, ss = pcall(require, "smart-splits")
  if ok then
    ss.move_cursor_down()
  end
end, { desc = "SmartSplits - Focus Down" })
map("n", "<C-k>", function()
  local ok, ss = pcall(require, "smart-splits")
  if ok then
    ss.move_cursor_up()
  end
end, { desc = "SmartSplits - Focus Up" })
map("n", "<C-l>", function()
  local ok, ss = pcall(require, "smart-splits")
  if ok then
    ss.move_cursor_right()
  end
end, { desc = "SmartSplits - Focus Right" })

map("n", "<A-left>", function()
  local ok, ss = pcall(require, "smart-splits")
  if ok then
    ss.resize_left()
  end
end, { desc = "SmartSplits - Resize Left" })
map("n", "<A-down>", function()
  local ok, ss = pcall(require, "smart-splits")
  if ok then
    ss.resize_down()
  end
end, { desc = "SmartSplits - Resize Down" })
map("n", "<A-up>", function()
  local ok, ss = pcall(require, "smart-splits")
  if ok then
    ss.resize_up()
  end
end, { desc = "SmartSplits - Resize Up" })
map("n", "<A-right>", function()
  local ok, ss = pcall(require, "smart-splits")
  if ok then
    ss.resize_right()
  end
end, { desc = "SmartSplits - Resize Right" })

map("n", "<A-h>", function()
  local ok, ss = pcall(require, "smart-splits")
  if ok then
    ss.resize_left()
  end
end, { desc = "SmartSplits - Resize Left" })
map("n", "<A-j>", function()
  local ok, ss = pcall(require, "smart-splits")
  if ok then
    ss.resize_down()
  end
end, { desc = "SmartSplits - Resize Down" })
map("n", "<A-k>", function()
  local ok, ss = pcall(require, "smart-splits")
  if ok then
    ss.resize_up()
  end
end, { desc = "SmartSplits - Resize Up" })
map("n", "<A-l>", function()
  local ok, ss = pcall(require, "smart-splits")
  if ok then
    ss.resize_right()
  end
end, { desc = "SmartSplits - Resize Right" })

map("n", "<leader><leader>h", function()
  local ok, ss = pcall(require, "smart-splits")
  if ok then
    ss.swap_buf_left()
  end
end, { desc = "SmartSplits - Swap Buffer Left" })
map("n", "<leader><leader>j", function()
  local ok, ss = pcall(require, "smart-splits")
  if ok then
    ss.swap_buf_down()
  end
end, { desc = "SmartSplits - Swap Buffer Down" })
map("n", "<leader><leader>k", function()
  local ok, ss = pcall(require, "smart-splits")
  if ok then
    ss.swap_buf_up()
  end
end, { desc = "SmartSplits - Swap Buffer Up" })
map("n", "<leader><leader>l", function()
  local ok, ss = pcall(require, "smart-splits")
  if ok then
    ss.swap_buf_right()
  end
end, { desc = "SmartSplits - Swap Buffer Right" })

-- ── IncRename ─────────────────────────────────────────────────
if settings.editor.inc_rename then
  map("n", "<leader>rn", ":IncRename ", { silent = true, noremap = true, desc = "IncRename" })
else
  map("n", "<leader>rn", function()
    vim.lsp.buf.rename()
  end, { desc = "LSP rename" })
end

-- ── Noice ─────────────────────────────────────────────────────
map("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Noice - Dismiss Notifications" })

-- ── Trouble ───────────────────────────────────────────────────
-- Trouble 关闭时不注册：gd/gi/gD 交还 override/lspconfig.lua 的 buffer-local LSP 映射
if settings.ui.trouble then
  map("n", "<leader>tr", ":TroubleToggle<CR>", { desc = "Trouble - Toggle" })
  map("n", "<leader>wd", ":TroubleToggle workspace_diagnostics<CR>", { desc = "Trouble - Workspace Diagnostics" })
  map("n", "<leader>cq", "<CMD>TroubleToggle quickfix<CR>", { desc = "Trouble - Quickfix" })
  map("n", "<leader>td", "<CMD>TodoTrouble<CR>", { desc = "Trouble - Todo" })
  map("n", "gd", "<CMD>Trouble lsp_definitions<CR>", { desc = "Trouble - Definition" })
  map("n", "gi", "<CMD>Trouble lsp_implementations<CR>", { desc = "Trouble - Implementations" })
  map("n", "gD", "<CMD>Trouble lsp_type_definitions<CR>", { desc = "Trouble - Type Definition" })
end

-- ── Goto Preview ──────────────────────────────────────────────
map("n", "<leader>pd", function()
  require("goto-preview").goto_preview_definition()
end, { desc = "GotoPreview - Definition" })
map("n", "<leader>pt", function()
  require("goto-preview").goto_preview_type_definition()
end, { desc = "GotoPreview - Type Definition" })
map("n", "<leader>pi", function()
  require("goto-preview").goto_preview_implementation()
end, { desc = "GotoPreview - Implementation" })
map("n", "<leader>pD", function()
  require("goto-preview").goto_preview_declaration()
end, { desc = "GotoPreview - Declaration" })
map("n", "<leader>px", function()
  require("goto-preview").close_all_win()
end, { desc = "GotoPreview - Close All" })
map("n", "<leader>pr", function()
  require("goto-preview").goto_preview_references()
end, { desc = "GotoPreview - References" })

-- ── Harpoon ───────────────────────────────────────────────────
map("n", "<leader>ha", function()
  require("harpoon"):list():append()
end, { desc = "Harpoon - Add" })
map("n", "<leader>hl", function()
  local harpoon = require "harpoon"
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon - List" })
map("n", "<A-P>", function()
  require("harpoon"):list():prev()
end, { desc = "Harpoon - Previous" })
map("n", "<A-N>", function()
  require("harpoon"):list():next()
end, { desc = "Harpoon - Next" })
map("n", "<leader>h1", function()
  require("harpoon"):list():select(1)
end, { desc = "Harpoon - 1" })
map("n", "<leader>h2", function()
  require("harpoon"):list():select(2)
end, { desc = "Harpoon - 2" })
map("n", "<leader>h3", function()
  require("harpoon"):list():select(3)
end, { desc = "Harpoon - 3" })
map("n", "<leader>h4", function()
  require("harpoon"):list():select(4)
end, { desc = "Harpoon - 4" })
map("n", "<leader>h5", function()
  require("harpoon"):list():select(5)
end, { desc = "Harpoon - 5" })
map("n", "<leader>h6", function()
  require("harpoon"):list():select(6)
end, { desc = "Harpoon - 6" })

-- ── Hop ───────────────────────────────────────────────────────
map({ "n", "v" }, "<leader>hw", "<Cmd>HopWord<cr>", { desc = "Hop - Word" })
map({ "n", "v" }, "<leader>h/", "<Cmd>HopPattern<cr>", { desc = "Hop - Pattern" })
map({ "n", "v" }, "<leader>hc", "<Cmd>HopChar1<cr>", { desc = "Hop - Character" })
map({ "n", "v" }, "<leader>hs", "<Cmd>HopChar2<cr>", { desc = "Hop - 2 Characters" })
map({ "n", "v" }, "<M-f>", "<Cmd>HopChar1<cr>", { desc = "Hop - Character" })

-- ── CopilotChat ───────────────────────────────────────────────
if settings.editor.copilot_chat then
  map("n", "<A-c>", "<cmd>CopilotChat<CR>", { desc = "CopilotChat - Enable" })
  map({ "n", "v" }, "<leader>ae", "<cmd>CopilotChatExplain<cr>", { desc = "CopilotChat - Explain code" })
  map({ "n", "v" }, "<leader>at", "<cmd>CopilotChatTests<cr>", { desc = "CopilotChat - Generate tests" })
  map({ "n", "v" }, "<leader>af", "<cmd>CopilotChatFix<cr>", { desc = "CopilotChat - Fix code" })
  map({ "n", "v" }, "<leader>ar", "<cmd>CopilotChatRefactor<cr>", { desc = "CopilotChat - Refactor code" })
  map({ "n", "v" }, "<leader>ao", "<cmd>CopilotChatOptimize<cr>", { desc = "CopilotChat - Optimize code" })
  map({ "n", "v" }, "<leader>ad", "<cmd>CopilotChatDocs<cr>", { desc = "CopilotChat - Generate Docs" })
  map({ "n", "v" }, "<leader>av", "<cmd>CopilotChatToggle<cr>", { desc = "CopilotChat - Toggle Vsplit" })
  map({ "n", "v" }, "<leader>ax", ":CopilotChatInline<cr>", { desc = "CopilotChat - Inline chat" })
  map({ "n", "v" }, "<leader>ai", function()
    local input = vim.fn.input "Ask Copilot: "
    if input ~= "" then
      vim.cmd("CopilotChat " .. input)
    end
  end, { desc = "CopilotChat - Ask input" })
  map({ "n", "v" }, "<leader>aq", function()
    local input = vim.fn.input "Quick Chat: "
    if input ~= "" then
      vim.cmd("CopilotChatBuffer " .. input)
    end
  end, { desc = "CopilotChat - Quick chat" })
  map({ "n", "v" }, "<leader>ac", "<cmd>CopilotChatCommit<cr>", { desc = "CopilotChat - Commit Message" })
  map({ "n", "v" }, "<leader>as", "<cmd>CopilotChatCommitStaged<cr>", { desc = "CopilotChat - Commit Message Staged" })
  map({ "n", "v" }, "<leader>aF", "<cmd>CopilotChatFixDiagnostic<cr>", { desc = "CopilotChat - Fix Diagnostic" })
  map({ "n", "v" }, "<leader>aR", "<cmd>CopilotChatReset<cr>", { desc = "CopilotChat - Clear buffer and chat history" })
end

-- ── Go ────────────────────────────────────────────────────────
map("n", "<leader>lst", "<CMD>GoFillStruct<CR>", { desc = "Go - FillStruct", noremap = true, silent = true })
map("n", "<leader>lsw", "<CMD>GoFillSwitch<CR>", { desc = "Go - FillSwitch", noremap = true, silent = true })
map("n", "<leader>lif", "<CMD>GoIfErr<CR>", { desc = "Go - IfErr", noremap = true, silent = true })
map("n", "<leader>lm", "<CMD>GoMake<CR>", { desc = "Go - Async Make", noremap = true, silent = true })
map("n", "<leader>lr", "<CMD>GoRun<CR>", { desc = "Go - Run", noremap = true, silent = true })
map("n", "<leader>lt", "<CMD>GoTest<CR>", { desc = "Go - Test", noremap = true, silent = true })
map("n", "<leader>lw", "<CMD>GoTestSum -w<CR>", { desc = "Go - Test Watch", noremap = true, silent = true })
map("n", "<leader>lx", "<CMD>GoTermClose<CR>", { desc = "Go - Close Term", noremap = true, silent = true })
map("n", "<leader>lk", "<CMD>GoDoc<CR>", { desc = "Go - Doc", noremap = true, silent = true })
map("n", "<leader>lat", "<CMD>GoAddTag<CR>", { desc = "Go - Add Tag", noremap = true, silent = true })
map("n", "<leader>ldt", "<CMD>GoRmTag<CR>", { desc = "Go - Remove Tag", noremap = true, silent = true })
map("n", "<leader>lc", function()
  require("go.comment").gen()
end, { desc = "Go - Comment", noremap = true, silent = true })
map("n", "<leader>ll", "<CMD>GoRmTag<CR>", { desc = "Go - Remove Tag", noremap = true, silent = true })
map("n", "<leader>li", "<CMD>GoToggleInlay<CR>", { desc = "Go - Toggle Inlay Hints", noremap = true, silent = true })

-- ── Pomo ──────────────────────────────────────────────────────
map("n", "<leader>pm", function()
  local ok, pomo = pcall(require, "pomo")
  if not ok then
    return
  end
  if pomo.get_first_to_finish() then
    vim.notify("a Timer is already running", vim.log.levels.INFO)
    return
  end
  pomo.start_timer(25 * 60, "work")
end, { desc = "Pomo - Start new Timer", noremap = true, silent = true })
map("n", "<leader>ps", function()
  local ok, pomo = pcall(require, "pomo")
  if ok then
    pomo.stop_timer()
  end
end, { desc = "Pomo - Stop Timer", noremap = true, silent = true })

-- 终端：原先 <leader>t = split | terminal，现已移除（终端统一走 toggleterm 的 <C-\>），
-- <leader>t 让给 kd 翻译插件。

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
map("n", "<leader>_", "<C-x>", { desc = "Decrement number" })
map("n", "<leader>dw", 'vb"_d', { desc = "Delete word backward" })
map("n", "<leader>all", "gg<S-v>G", { desc = "Select all" })

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = set_terminal_keymaps,
})

nomap("n", "<leader>cc")
map("n", "gr", "<cmd>FzfLua lsp_references<CR>", { noremap = true, silent = true, desc = "LSP - References" })

o.jumpoptions = "stack"
