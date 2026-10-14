-- src/packages/neovim/base/__config/lua/autocommands.lua

-- no auto continue comments on the next line
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("DisableNewLineAutoCommentString", {}),
	callback = function()
		vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
	end,
})

-- higligth yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "Highlight section on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})

-- open help in vertical splits
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	command = "wincmd L",
})

-- syntax highlighting for dotenv files
vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
	pattern = { ".env", ".env.*" },
	callback = function()
		vim.bo.filetype = "dosini"
	end,
})

-- LSP default keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local fzf = require("fzf-lua")
		local bufnr = event.buf
		vim.cmd.setlocal("signcolumn=yes")
		vim.bo[bufnr].bufhidden = "hide"

		local function desc(description)
			return { noremap = true, silent = true, buffer = bufnr, desc = "LSP: " .. description }
		end
		-- Keybinds
		-- Definition
		vim.keymap.set("n", "gd", fzf.lsp_definitions, desc("[G]o to [D]efinition"))
		-- Type definition
		vim.keymap.set("n", "gtd", fzf.lsp_typedefs, desc("[G]o to [T]ype [D]efinition"))
		-- Declaration
		vim.keymap.set("n", "gD", fzf.lsp_declarations, desc("[G]o to [D]eclarations"))
		-- References
		vim.keymap.set("n", "gr", fzf.lsp_references, desc("[G]o to [R]eferences"))
		-- Implementation
		vim.keymap.set("n", "gi", fzf.lsp_implementations, desc("[G]o to [I]mplementations"))
		-- Document symbols
		vim.keymap.set("n", "gs", fzf.lsp_document_symbols, desc("[F]ind document [S]ymbols"))
		-- Code actions
		vim.keymap.set("n", "<leader>ca", fzf.lsp_code_actions, desc("[G]o to [C]ode [A]ction"))
		-- Rename
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, desc("[R]e[N]ame"))
		-- Signature
		vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, desc("[S]ignature [H]elp"))
		vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, desc("Signature Help"))
		-- Documentation
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Docuemntation" })
		-- Toggle Inlay Hints
		vim.keymap.set("n", "<leader>th", function()
			local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
			vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = 0 })
		end, desc("Toggle Inlay [H]ints"))

		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
			local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
				end,
			})
		end
	end,
})
