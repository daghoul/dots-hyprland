--- See https://wiki.hyprland.org/Configuring/Monitors/
hl.monitor({
	output = "",
	mode = "highres@highrr",
	position = "auto",
	scale = "auto",
	cm = "auto",
	bitdepth = 8,
	-- sdr_max_luminance = 100,
	-- sdrbrightness = 1.2,
	-- sdrsaturation = 0.98,
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		numlock_by_default = true,

		accel_profile = "flat",
		follow_mouse = 1,
		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = false,
		},
	},
})

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		-- Gaps and border
		gaps_in = 4,
		gaps_out = 5,
		gaps_workspaces = 50,

		border_size = 1,

		resize_on_border = true,

		no_focus_fallback = true,
		allow_tearing = true, -- This just allows the `immediate` window rule to work
		snap = {
			enabled = true,
			window_gap = 4,
			monitor_gap = 5,
			respect_gaps = true,
		},
	},
	decoration = {
		-- 2 = circle, higher = squircle, 4 = very obvious squircle
		-- Fuck clearly visible squircles. 100% Apple brainrot.
		rounding_power = 2.5,
		rounding = 18,

		blur = {
			enabled = false,
			xray = true,
			special = false,
			new_optimizations = true,
			size = 10,
			passes = 3,
			brightness = 1,
			noise = 0.05,
			contrast = 0.89,
			vibrancy = 0.5,
			vibrancy_darkness = 0.5,
			popups = false,
			popups_ignorealpha = 0.6,
			input_methods = true,
			input_methods_ignorealpha = 0.8,
		},
		shadow = {
			enabled = false,
			range = 20,
			offset = { 0, 2 },
			render_power = 10,
			color = "rgba(00000020)",
		},
		-- Dim
		dim_inactive = true,
		dim_strength = 0.05,
		dim_special = 0.2,
	},
	animations = {
		enabled = true,
	},
	dwindle = {
		preserve_split = true,
		smart_split = false,
		smart_resizing = false,
		-- precise_mouse_move = true,
	},
})

-- Curves
hl.curve("expressiveFastSpatial", {
	type = "bezier",
	points = { { 0.42, 1.67 }, { 0.21, 0.90 } },
})
hl.curve("expressiveSlowSpatial", {
	type = "bezier",
	points = { { 0.39, 1.29 }, { 0.35, 0.98 } },
})
hl.curve("expressiveDefaultSpatial", {
	type = "bezier",
	points = { { 0.38, 1.21 }, { 0.22, 1.00 } },
})
hl.curve("emphasizedDecel", {
	type = "bezier",
	points = { { 0.05, 0.7 }, { 0.1, 1 } },
})
hl.curve("emphasizedAccel", {
	type = "bezier",
	points = { { 0.3, 0 }, { 0.8, 0.15 } },
})
hl.curve("standardDecel", {
	type = "bezier",
	points = { { 0, 0 }, { 0, 1 } },
})
hl.curve("menu_decel", {
	type = "bezier",
	points = { { 0.1, 1 }, { 0, 1 } },
})
hl.curve("menu_accel", {
	type = "bezier",
	points = { { 0.52, 0.03 }, { 0.72, 0.08 } },
})
hl.curve("stall", {
	type = "bezier",
	points = { { 1, -0.1 }, { 0.7, 0.85 } },
})
-- Configs
-- windows
hl.animation({
	leaf = "windowsIn",
	enabled = true,
	speed = 3,
	bezier = "emphasizedDecel",
	style = "popin 80%",
})
hl.animation({
	leaf = "fadeIn",
	enabled = true,
	speed = 3,
	bezier = "emphasizedDecel",
})
hl.animation({
	leaf = "windowsOut",
	enabled = true,
	speed = 2,
	bezier = "emphasizedDecel",
	style = "popin 90%",
})
hl.animation({
	leaf = "fadeOut",
	enabled = true,
	speed = 2,
	bezier = "emphasizedDecel",
})
hl.animation({
	leaf = "windowsMove",
	enabled = true,
	speed = 3,
	bezier = "emphasizedDecel",
	style = "slide",
})
hl.animation({
	leaf = "border",
	enabled = true,
	speed = 10,
	bezier = "emphasizedDecel",
})

-- layers
hl.animation({
	leaf = "layersIn",
	enabled = true,
	speed = 2.7,
	bezier = "emphasizedDecel",
	style = "popin 93%",
})
hl.animation({
	leaf = "layersOut",
	enabled = true,
	speed = 2.4,
	bezier = "menu_accel",
	style = "popin 94%",
})
-- fade
hl.animation({
	leaf = "fadeLayersIn",
	enabled = true,
	speed = 0.5,
	bezier = "menu_decel",
})
hl.animation({
	leaf = "fadeLayersOut",
	enabled = true,
	speed = 2.7,
	bezier = "menu_decel",
})
-- workspaces
hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 7,
	bezier = "menu_decel",
	style = "slide",
})
-- specialWorkspace
hl.animation({
	leaf = "specialWorkspaceIn",
	enabled = true,
	speed = 2.8,
	bezier = "emphasizedDecel",
	style = "slidevert",
})
hl.animation({
	leaf = "specialWorkspaceOut",
	enabled = true,
	speed = 1.2,
	bezier = "emphasizedAccel",
	style = "slidevert",
})
-- zoom
hl.animation({
	leaf = "zoomFactor",
	enabled = true,
	speed = 3,
	bezier = "standardDecel",
})

hl.config({
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		vrr = 0,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
		animate_manual_resizes = false,
		animate_mouse_windowdragging = false,
		enable_swallow = false,
		swallow_regex = "(foot|kitty|allacritty|Alacritty)",
		on_focus_under_fullscreen = 2,
		allow_session_lock_restore = true,
		session_lock_xray = true,
		initial_workspace_tracking = false,
		focus_on_activate = true,
	},

	binds = {
		scroll_event_delay = 0,
		hide_special_on_workspace_change = true,
	},

	cursor = {
		zoom_factor = 1,
		zoom_rigid = false,
		zoom_disable_aa = true,
		hotspot_padding = 1,
	},

	xwayland = {
		force_zero_scaling = true,
	},
})

hl.config({
	debug = {
		-- overlay = false,
		-- vfr = false,
	},
})
