-- src/packages/neovim/base/__config/lua/keymaps.lua
local opts = { noremap = true, silent = true }
local fzfLua = require("fzf-lua")

-- Mapleader
vim.g.mapleader = " "
vim.g.maplocaleader = " "

-- Insert mode out
-- vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true, desc = "Go back to normal mode." })
-- vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true, desc = "Go back to normal mode." })

-- Important File Explorer
vim.keymap.set("n", "-", "<cmd>Oil<CR>", { noremap = true, silent = true, desc = "File Explorer." })
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { noremap = true, silent = true, desc = "File Tree" })

-- Clear Highlights when pressing Esc in a search
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, silent = true, desc = "Clear Search Highlight" })

-- Diagnostics
vim.keymap.set(
	"n",
	"<leader>q",
	vim.diagnostic.open_float,
	{ noremap = true, silent = true, desc = "Open diagnostic [Q]uickfix." }
)

-- Split windows
vim.keymap.set("n", "<leader>vs", "<cmd>vsplit<CR>", { noremap = true, silent = true, desc = "[V]ertical [S]plit." })
vim.keymap.set("n", "<leader>hs", "<cmd>split<CR>", { noremap = true, silent = true, desc = "[H]orizontal [S]plit." })
vim.keymap.set("n", "<c-l>", "<c-w><c-l>", opts)
vim.keymap.set("n", "<c-h>", "<c-w><c-h>", opts)

-- Buffer
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { noremap = true, silent = true, desc = "[B]uffer [D]elete." })
vim.keymap.set("n", "<leader>bda", "<cmd>%bd<CR>", { noremap = true, silent = true, desc = "[B]uffer [D]elete [A]ll" })

-- Files
vim.keymap.set(
	"n",
	"<leader>cs",
	fzfLua.colorschemes,
	{ noremap = true, silent = true, desc = "Find [C]olor[S]chemes." }
)
vim.keymap.set("n", "<leader>ff", fzfLua.files, { noremap = true, silent = true, desc = "[F]ind [F]iles." })
vim.keymap.set("n", "<leader>fb", fzfLua.buffers, { noremap = true, silent = true, desc = "[F]ind [B]uffers." })
vim.keymap.set("n", "<leader>fk", fzfLua.keymaps, { noremap = true, silent = true, desc = "[F]ind [K]eymaps." })
vim.keymap.set(
	"n",
	"<leader>fr",
	fzfLua.resume,
	{ noremap = true, silent = true, desc = "[F]ind [R]esume of the previous files." }
)
vim.keymap.set("n", "<leader>fw", fzfLua.grep_cword, { noremap = true, silent = true, desc = "[F]ind current [W]ord." })
vim.keymap.set("n", "<leader>fg", fzfLua.grep, { noremap = true, silent = true, desc = "[F]ind by [G]rep." })

-- Search & Replace
vim.keymap.set("n", "<leader>sr", "<cmd>GrugFar<CR>", { noremap = true, silent = true, desc = "[S]earch & [R]eplace" })

-- Colorizer Toggle
vim.keymap.set(
	"n",
	"<leader>ct",
	"<cmd>ColorizerToggle<CR>",
	{ noremap = true, silent = true, desc = "[C]olorizer [T]oggle" }
)
