local wezterm = require("wezterm")
local config = {}

-- Font configuration - smaller size for zoomed out appearance
config.font_size = 8.0

-- Disable flow control to prevent Ctrl+S from freezing terminal
config.enable_kitty_keyboard = true
config.use_fancy_tab_bar = true

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
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
	-- Next pane
	{
		key = ">",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Next"),
	},
}

return config
