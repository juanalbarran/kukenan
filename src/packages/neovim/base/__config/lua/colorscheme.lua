-- src/packages/neovim/base/__config/lua/colorscheme.lua
-- vim.cmd.colorscheme('zenbones')
-- vim.cmd.colorscheme("alabaster")
-- src/packages/neovim/base/__config/lua/colorscheme.lua
require("vague").setup({
	colors = {
		bg = "#131313",
	},
})
-- 1. CONFIGURATION
-- Point to the file managed by toggle-theme.sh
local theme_file_path = vim.fn.expand("$HOME/.cache/style/mode")
local uv = vim.uv or vim.loop -- Handles both new and old Neovim versions

-- !!! CHANGE THESE TO YOUR INSTALLED THEMES !!!
local DARK_THEME = "luna" --"tokyonight-moon" -- Example: "catppuccin", "vague", "gruvbox" "koda" "luna"
local LIGHT_THEME = "alabaster" -- "onedark" -- Example: "alabaster", "dayfox", "rose-pine-dawn"

-- 2. HELPER FUNCTIONS

local function read_file(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end
	local content = file:read("*line") -- Read first line ("dark" or "light")
	file:close()
	return content
end

local function apply_theme(mode)
	-- Clean the string
	mode = mode and mode:gsub("%s+", "") or "dark"

	local target_theme = (mode == "light") and LIGHT_THEME or DARK_THEME
	local target_bg = (mode == "light") and "light" or "dark"

	-- Attempt to load
	vim.o.background = target_bg
	local ok, _ = pcall(vim.cmd.colorscheme, target_theme)

	if target_theme == "alabaster" then
		local bgrnd = "#ffffff"
		vim.api.nvim_set_hl(0, "Normal", { bg = bgrnd })
		vim.api.nvim_set_hl(0, "NormalNC", { bg = bgrnd })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = bgrnd })
		vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = bgrnd })
	end

	if not ok then
		-- Return false so we know it failed
		return false
	end
	return true
end

-- 3. WATCHER LOGIC
local function watch_theme_change()
	local handle = uv.new_fs_event()

	local function unwatch()
		if handle then
			uv.fs_event_stop(handle)
		end
	end

	local function on_event(err, filename, events)
		if err then
			unwatch()
			return
		end

		-- Schedule UI updates on the main thread
		vim.schedule(function()
			local new_mode = read_file(theme_file_path)
			apply_theme(new_mode)

			-- Restart watcher to handle file replacements (inode changes)
			unwatch()
			watch_theme_change()
		end)
	end

	if handle then
		uv.fs_event_start(handle, theme_file_path, {}, on_event)
	end
end

-- 4. INITIALIZATION (Run once on startup)
local current_mode = read_file(theme_file_path)
local success = apply_theme(current_mode)

-- Attempt 2: If immediate load failed, wait for VimEnter (Plugins guaranteed to be loaded)
if not success then
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			apply_theme(current_mode)
		end,
		once = true, -- Only run this once on startup
	})
end
-- Start the watcher
watch_theme_change()
