-- src/packages/neovim/base/__confgi/lua/blink-cmp.lua
require("blink.cmp").setup({
	keymap = { preset = "default" },
	sources = {
		default = { "lsp", "path", "buffer", "snippets" },
	},
	snippets = { preset = "luasnip" },
	completion = {
		menu = { border = "single" },
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 500,
			window = { border = "single" },
		},
		ghost_text = { enabled = false },
		accept = { auto_brackets = { enabled = false } },
	},
	signature = { enabled = true, window = { border = "single" } },
})
