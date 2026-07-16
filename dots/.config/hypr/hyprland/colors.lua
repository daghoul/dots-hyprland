hl.config({
	general = {
		col = {
			active_border = "rgba(ffffffee)",
			inactive_border = "rgba(595959aa)",
		},
	},
	decoration = {
			shadow = {
				color = "rgba(00000020)",
		},
	},
})

hl.window_rule({
	match = { pin = 1 },
	border_color = "rgba(efbd86AA) rgba(efbd8677)",
	border_size = 2,
})

hl.window_rule({
	match = { fullscreen_state_internal = 1, fullscreen_state_client = 1 },
	border_color = "rgba(94622dff)",
})

hl.window_rule({
	match = { float = 1 },
	border_color = "rgba(efbd86ff)",
})
