-- src/packages/neovim/base/__config/lua/zdiff.lua
require("zdiff").setup({
	default_branch = "main",
})
vim.keymap.set("n", "<leader>zd", function()
	require("zdiff").open()
end, { noremap = true, silent = true, desc = "[Z]diff [D]iff (uncommitted)" })

vim.keymap.set("n", "<leader>zD", function()
	require("zdiff").open("main")
end, { noremap = true, silent = true, desc = "[Z]diff [D]iff (vs main)" })
