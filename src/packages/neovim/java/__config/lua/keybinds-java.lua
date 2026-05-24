-- src/packages/neovim/java/__config/lua/keybinds-java.lua

vim.keymap.set("n", "<leader>jc", "<cmd>JavaClass<CR>", { desc = "[J]ava [C]lass", noremap = true, silent = true })
vim.keymap.set(
	"n",
	"<leader>ji",
	"<cmd>JavaInterface<CR>",
	{ desc = "[J]ava [I]nterface", noremap = true, silent = true }
)
vim.keymap.set("n", "<leader>je", "<cmd>JavaEnum<CR>", { desc = "[J]ava [E]num", noremap = true, silent = true })
vim.keymap.set("n", "<leader>jr", "<cmd>JavaRecord<CR>", { desc = "[J]ava [R]ecord", noremap = true, silent = true })
vim.keymap.set("n", "<leader>jn", "<cmd>JavaNew<CR>", { desc = "[J]ava [N]ew", noremap = true, silent = true })
vim.keymap.set(
	"n",
	"<leader>ja",
	"<cmd>JavaAbstract<CR>",
	{ desc = "[J]ava [A]bstract", noremap = true, silent = true }
)

vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function(event)
		local bufnr = event.buf

		local function exec_jdtls(command, get_args)
			return function()
				local clients = vim.lsp.get_clients({ name = "jdtls", bufnr = bufnr })
				if #clients == 0 then
					vim.notify("JDTLS client not found", vim.log.levels.WARN)
					return
				end
				local client = clients[1]
				client:exec_cmd({
					command = command,
					arguments = get_args(client, bufnr),
				}, { bufnr = bufnr })
			end
		end

		vim.keymap.set(
			"n",
			"<leader>io",
			exec_jdtls("java.edit.organizeImports", function(_, bnr)
				return { vim.uri_from_bufnr(bnr) }
			end),
			{ buffer = bufnr, silent = true, desc = "[J]ava [O]rganize Imports" }
		)

		vim.keymap.set(
			"v",
			"<leader>jv",
			exec_jdtls("java.action.extractVariable", function(client, bnr)
				local range = vim.lsp.util.make_range_params(0, client.offset_encoding).range
				return { vim.uri_from_bufnr(bnr), range }
			end),
			{ buffer = bufnr, silent = true, desc = "[J]ava Extract [V]ariable" }
		)

		vim.keymap.set(
			"v",
			"<leader>jm",
			exec_jdtls("java.action.extractMethod", function(client, bnr)
				local range = vim.lsp.util.make_range_params(0, client.offset_encoding).range
				return { vim.uri_from_bufnr(bnr), range }
			end),
			{ buffer = bufnr, silent = true, desc = "[J]ava Extract [M]ethod" }
		)

		vim.keymap.set("n", "<leader>jgs", function()
			vim.lsp.buf.code_action({ context = { only = { "source.generate.accessors" } }, apply = true })
		end, { buffer = bufnr, silent = true, desc = "[J]ava [G]enerate [S]etters/Getters" })

		vim.keymap.set("n", "<leader>jgc", function()
			vim.lsp.buf.code_action({ context = { only = { "source.generate.constructors" } }, apply = true })
		end, { buffer = bufnr, silent = true, desc = "[J]ava [G]enerate [C]onstructor" })

		vim.keymap.set("n", "<leader>jgt", function()
			vim.lsp.buf.code_action({ context = { only = { "source.generate.toString" } }, apply = true })
		end, { buffer = bufnr, silent = true, desc = "[J]ava [G]enerate [T]oString" })

		vim.keymap.set("n", "<leader>jgh", function()
			vim.lsp.buf.code_action({ context = { only = { "source.generate.hashCodeEquals" } }, apply = true })
		end, { buffer = bufnr, silent = true, desc = "[J]ava [G]enerate [H]ashCode/Equals" })
	end,
})
