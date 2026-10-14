-- src/packages/neovim/base/__config/lua/colorscheme.lua
-- Paints Neovim with the current sarisarinama theme through aether.nvim.
-- sarisarinama writes the resolved palette to palette.json on every
-- `theme set` and Home Manager switch; Neovim only reads it.
require("vague").setup({
	colors = {
		bg = "#131313",
	},
})

local uv = vim.uv or vim.loop

-- 1. CONFIGURATION
local state_dir = vim.fn.expand("$HOME/.local/state/sarisarinama")
local palette_name = "palette.json"
local palette_path = state_dir .. "/" .. palette_name
local FALLBACK_THEME = "vague"

-- 2. HELPER FUNCTIONS

local function read_file(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end
	local content = file:read("*a")
	file:close()
	return content
end

-- sarisarinama keys (omarchy quattro) -> aether colors, as omarchy's
-- default/themed/neovim.lua.tpl maps them.
local function aether_colors(p)
	return {
		bg = p.background,
		dark_bg = p.dark_background,
		darker_bg = p.darker_background,
		lighter_bg = p.lighter_background,

		fg = p.foreground,
		dark_fg = p.dark_foreground,
		light_fg = p.light_foreground,
		bright_fg = p.bright_foreground,
		muted = p.muted,

		red = p.red,
		yellow = p.yellow,
		orange = p.orange,
		green = p.green,
		cyan = p.cyan,
		blue = p.blue,
		magenta = p.magenta,
		brown = p.brown,

		bright_red = p.bright_red,
		bright_yellow = p.bright_yellow,
		bright_green = p.bright_green,
		bright_cyan = p.bright_cyan,
		bright_blue = p.bright_blue,
		bright_magenta = p.bright_magenta,

		accent = p.accent,
		cursor = p.bright_foreground,
		foreground = p.foreground,
		background = p.background,
		selection = p.selection,
		-- palette.json has no selection_* keys; without these aether keeps
		-- its own dark defaults, unreadable on a light theme.
		selection_foreground = p.selection_foreground or p.bright_foreground,
		selection_background = p.selection_background or p.selection,
	}
end

-- aether caches its palette in its modules and lualine caches the aether
-- theme; drop both so the next load sees the new colours.
local function clear_aether_modules()
	for name in pairs(package.loaded) do
		if (name:match("^aether") and name ~= "aether.hotreload") or name:match("^lualine%.themes%.aether") then
			package.loaded[name] = nil
		end
	end
end

local last_content = nil

-- Returns true when the palette was applied (or is already applied).
local function apply_palette()
	local content = read_file(palette_path)
	if not content then
		return false
	end
	if content == last_content then
		return true
	end

	local ok, palette = pcall(vim.json.decode, content)
	if not ok or type(palette) ~= "table" then
		vim.notify("colorscheme: cannot read " .. palette_path, vim.log.levels.WARN)
		return false
	end

	clear_aether_modules()
	require("aether").setup({ colors = aether_colors(palette) })
	vim.o.background = (palette.mode == "light") and "light" or "dark"
	ok = pcall(vim.cmd.colorscheme, "aether")
	if not ok then
		return false
	end

	last_content = content
	return true
end

-- 3. WATCHER LOGIC
-- sarisarinama renames a temporary file over palette.json, so the file's
-- inode changes on every write: watch the directory, not the file.
local watcher = nil
local debounce = nil

local function watch_palette()
	-- Created here so a palette written after startup is still seen.
	vim.fn.mkdir(state_dir, "p")
	watcher = uv.new_fs_event()
	debounce = uv.new_timer()
	if not watcher or not debounce then
		return
	end

	watcher:start(state_dir, {}, function(err, filename)
		if err or filename ~= palette_name then
			return
		end
		-- A rename arrives as several events; apply once they settle.
		debounce:stop()
		debounce:start(50, 0, vim.schedule_wrap(apply_palette))
	end)
end

-- 4. INITIALIZATION
if not apply_palette() then
	vim.o.background = "dark"
	pcall(vim.cmd.colorscheme, FALLBACK_THEME)
end
watch_palette()
