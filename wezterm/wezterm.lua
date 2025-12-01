local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	-- window:gui_window():maximize()
	window:gui_window():toggle_fullscreen()
	pane:send_text('t\n') -- Start tmux session named 'main'
end)

-- wezterm.on('window-resized', function(window, pane)
-- 	window:maximize()
-- end)


return {
	adjust_window_size_when_changing_font_size = false,
	enable_wayland = false,
	color_scheme = 'Catppuccin Mocha',
	enable_tab_bar = false,
	font_size = 13.0,
	font = wezterm.font_with_fallback {
		'JetBrains Mono',
		'Noto Color Emoji',  -- For emoji support
		'Symbols Nerd Font', -- For programming symbols
		'DejaVu Sans Mono',  -- Fallback for missing chars
	},
	-- window_background_opacity = 0.98,
	window_decorations = 'NONE',
	keys = {
		{
			key = 'q',
			mods = 'CTRL',
			action = wezterm.action.ToggleFullScreen,
		},
		{
			key = '\'',
			mods = 'CTRL',
			action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
		},
		{
			key = 'End',
			mods = 'NONE', -- Ou omita 'mods' se não houver modificadores
			action = wezterm.action.SendKey({ key = 'End' }),
		},
		{
			key = 'Home',
			mods = 'NONE', -- Ou omita 'mods' se não houver modificadores
			action = wezterm.action.SendKey({ key = 'Home' }),
		},
		{
			key = 'PageUp',
			mods = 'NONE', -- Ou omita 'mods' se não houver modificadores
			action = wezterm.action.SendKey({ key = 'PageUp' }),
		},
		{
			key = 'PageDown',
			mods = 'NONE', -- Ou omita 'mods' se não houver modificadores
			action = wezterm.action.SendKey({ key = 'PageDown' }),
		},
	},
	mouse_bindings = {
		-- Ctrl-click will open the link under the mouse cursor
		{
			event = { Up = { streak = 1, button = 'Left' } },
			mods = 'CTRL',
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},

}
