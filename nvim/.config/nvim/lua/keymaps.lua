vim.g.mapleader = " "
local map = vim.keymap.set

-- replaces selected text without loosing what you yanked
map("x", "p", [["_dP]], { desc = "Paste over selection without losing yanked text" })

-- Delete text without saving it to any register
map({ "n", "v"}, "<leader>d>", [["_d]], { desc = "Delete without yanking" })

map("i", "<C-c>", "<Esc>")
map("n", "<C-c>", ":nohl<CR>", { desc = "Clear search highlighting", silent = true })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
map("v", "K", ":m '>-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

map("v", "<", "<gv", { desc = "Unindent and keep selection" })
map("v", ">", ">gv", { desc = "Indent and keep selection" })

map("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

map("n", "<C-d>" , "<C-d>zz", { desc = "move down in buffer with cursor centered" })
map("n", "<C-u>" , "<C-u>zz", { desc = "move up in buffer with cursor centered" })

map("n", "<C-d>" , "<C-d>zz", { desc = "move down in buffer with cursor centered" })

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word cursor is on globally" })
map("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "makes file executable" })

map("n", "<leader>re", "<cmd>restart<cr>", { desc = "Restart config :restart)" })

-- native undotree
map("n", "<leader>u", function()
    vim.cmd.packadd("nvim.undotree")
    require("undotree").open()
end, { desc = "Toggle Builtin Undotree" })

-- obsidian
map("n", "<leader>nn", "<cmd>ObsidianNew<cr>", { desc = "New note" })
map("n", "<leader>nf", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Find notes" })
map("n", "<leader>ng", "<cmd>ObsidianSearch<cr>", { desc = "Search notes" })
map("n", "<leader>nd", "<cmd>ObsidianToday<cr>", { desc = "Daily note" })
map("n", "<leader>nb", "<cmd>ObsidianBacklinks<cr>", { desc = "Backlinks" })

map("n", "<leader>fg", function()
  require("telescope.builtin").live_grep()
end)


