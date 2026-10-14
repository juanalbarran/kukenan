--src/packages/neovim/base/__config/lua/options.lua
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true

vim.opt.clipboard = "unnamedplus"

vim.opt.showtabline = 0

vim.opt.termguicolors = true

vim.opt.showmode = false

vim.opt.scrolloff = 20

vim.opt.cmdheight = 0
vim.opt.showcmd = false

vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.breakindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undodir")

vim.opt.timeoutlen = 1000

vim.opt.winborder = "rounded"
-- autocommands

-- whenever a http file is open then this autocommand will force treesitter to higlight it
vim.api.nvim_create_autocmd("FileType", {
	pattern = "http",
	callback = function()
		-- When an http file is opened, forcefully enable treesitter highlighting for it
		vim.cmd("TSEnable highlight")
	end,
	desc = "Force Treesitter for HTTP files",
})
