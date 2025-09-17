local wezterm = require("wezterm")
local config = {}

-- Font configuration - smaller size for zoomed out appearance
config.font_size = 8.0

-- Disable flow control to prevent Ctrl+S from freezing terminal
-- Disable kitty keyboard protocol to fix DEL key issues in Neovim
config.enable_kitty_keyboard = false
config.use_fancy_tab_bar = true

-- Disable all confirmation dialogs
config.skip_close_confirmation_for_processes_named = { 'bash', 'sh', 'zsh', 'fish', 'tmux' }
config.window_close_confirmation = "NeverPrompt"

-- Start maximized without window decorations
config.window_decorations = "NONE"
config.initial_rows = 24
config.initial_cols = 80
wezterm.on("gui-startup", function()
	local tab, pane, window = wezterm.mux.spawn_window({})
	window:gui_window():maximize()
end)

-- Background image and transparency
-- convert ~/Downloads/vosges-photo-1.jpg -modulate 40,100,100 -blur 0x8 ~/Downloads/vosges-photo-1-dark-blurry.jpg
config.background = {
	{
		source = {
			File = "/home/mclement/Pictures/background/vosges-photo-1-dark-blurry.jpg",
		},
		opacity = 0.99,
	},
}

-- Key bindings for tab management
config.keys = {
	-- New tab
	{
		key = "t",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	-- Rename tab
	{
		key = "r",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- Next tab
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivateTabRelative(1),
	},
	-- Previous tab
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	-- Move tab left
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = wezterm.action.MoveTabRelative(-1),
	},
	-- Move tab right
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = wezterm.action.MoveTabRelative(1),
	},
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentTab({ confirm = false }),
	},
	-- Next pane
	{
		key = ">",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Next"),
	},
	-- Pane navigation with s/d/f/g (same as arrow keys)
	{
		key = "s",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "d",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "f",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "g",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
}

return config
