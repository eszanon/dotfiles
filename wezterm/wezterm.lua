local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

return {
	adjust_window_size_when_changing_font_size = false,
	color_scheme = 'Catppuccin Mocha',
	enable_tab_bar = false,
	font_size = 13.0,
	font = wezterm.font('JetBrains Mono'),	
	window_background_opacity = 0.97,
	window_decorations = 'RESIZE',	
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
