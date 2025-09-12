local wezterm = require("wezterm")
local config = {}

-- Background image and transparency
-- convert ~/Downloads/vosges-photo-1.jpg -modulate 40,100,100 -blur 0x8 ~/Downloads/vosges-photo-1-dark-blurry.jpg
config.background = {
	{
		source = {
			File = "Pictures/background/vosges-photo-1-dark-blurry.jpg",
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
	-- Toggle pane zoom
	{
		key = "m",
		mods = "CTRL|SHIFT",
		action = wezterm.action.TogglePaneZoomState,
	},
	-- Close tab
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
}

-- Mouse window dragging (default bindings)
config.mouse_bindings = {
	{
		event = { Drag = { streak = 1, button = "Left" } },
		mods = "SUPER",
		action = wezterm.action.StartWindowDrag,
	},
}

return config
