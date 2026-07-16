require("hyprland.variables")

local qsScripts = "$HOME/.config/quickshell/$qsConfig/scripts"
local hyprScripts = "$HOME/.config/hypr/hyprland/scripts"
local qsIpcCall = "qs -c $qsConfig ipc call"
local qsIsAlive = qsIpcCall .. " TEST_ALIVE"

-- Quickshell
hl.bind("SUPER + SUPER_L", hl.dsp.global("quickshell:searchToggleRelease"), { description = "Shell: Toggle search" })
hl.bind("SUPER + SUPER_R", hl.dsp.global("quickshell:searchToggleRelease"))
-- hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd(qsIsAlive .. " || pkill fuzzel || fuzzel"))
-- hl.bind("SUPER + SUPER_R", hl.dsp.exec_cmd(qsIsAlive .. " || pkill fuzzel || fuzzel"))

hl.bind("SUPER_L", hl.dsp.global("quickshell:workspaceNumber"), { ignore_mods = true, transparent = true })
hl.bind("SUPER_R", hl.dsp.global("quickshell:workspaceNumber"), { ignore_mods = true, transparent = true })
hl.bind(
	"SUPER_L",
	hl.dsp.global("quickshell:workspaceNumber"),
	{ ignore_mods = true, transparent = true, release = true }
)
hl.bind(
	"SUPER_R",
	hl.dsp.global("quickshell:workspaceNumber"),
	{ ignore_mods = true, transparent = true, release = true }
)
hl.bind("SUPER + Tab", hl.dsp.global("quickshell:overviewWorkspacesToggle"), { description = "Shell: Toggle overview" })
hl.bind("SUPER + C", hl.dsp.global("quickshell:overviewClipboardToggle"))
hl.bind("SUPER + Period", hl.dsp.global("quickshell:overviewEmojiToggle"))
hl.bind("SUPER + A", hl.dsp.global("quickshell:sidebarLeftToggle"), { description = "Shell: Toggle left sidebar" })
hl.bind("SUPER + ALT + A", hl.dsp.global("quickshell:sidebarLeftToggleDetach"))
hl.bind("SUPER + B", hl.dsp.global("quickshell:sidebarLeftToggle"))
hl.bind("SUPER + O", hl.dsp.global("quickshell:sidebarLeftToggle"))
hl.bind("SUPER + N", hl.dsp.global("quickshell:sidebarRightToggle"), { description = "Shell: Toggle right sidebar" })
hl.bind("SUPER + Slash", hl.dsp.global("quickshell:cheatsheetToggle"), { description = "Shell: Toggle cheatsheet" })
hl.bind("SUPER + K", hl.dsp.global("quickshell:oskToggle"), { description = "Shell: Toggle on-screen keyboard" })
hl.bind("SUPER + M", hl.dsp.global("quickshell:mediaControlsToggle"), { description = "Shell: Toggle media controls" })
hl.bind("SUPER + G", hl.dsp.global("quickshell:overlayToggle"), { description = "Shell: Toggle widget overlay" })
hl.bind(
	"CTRL + ALT + Delete",
	hl.dsp.global("quickshell:sessionToggle"),
	{ description = "Shell: Toggle session menu" }
)
hl.bind("SUPER + J", hl.dsp.global("quickshell:barToggle"), { description = "Shell: Toggle bar" })
hl.bind("SHIFT + SUPER + ALT + Slash", hl.dsp.exec_cmd("qs -p $HOME/.config/quickshell/$qsConfig/welcome.qml"))

hl.bind(
	"CTRL + SUPER + T",
	hl.dsp.global("quickshell:wallpaperSelectorToggle"),
	{ description = "Shell: Change wallpaper" }
)
hl.bind(
	"CTRL + SUPER + ALT + T",
	hl.dsp.global("quickshell:wallpaperSelectorRandom"),
	{ description = "Shell: Random wallpaper" }
)
hl.bind(
	"CTRL + SUPER + SHIFT + D",
	hl.dsp.global("quickshell:toggleLightDark"),
	{ description = "Shell: Toggle light/dark mode" }
)
hl.bind("CTRL + SUPER + T", hl.dsp.exec_cmd(qsIsAlive .. " || " .. qsScripts .. "/colors/switchwall.sh"))
hl.bind(
	"CTRL + SUPER + R",
	hl.dsp.exec_cmd("killall ydotool qs quickshell; qs -c $qsConfig &"),
	{ description = "Shell: Restart widgets" }
)

--##! Utilities
--# Screenshot, Record, OCR, Color picker, Clipboard history
hl.bind(
	"SUPER + C",
	hl.dsp.exec_cmd(
		qsIsAlive .. " || pkill fuzzel || cliphist list | fuzzel --match-mode fzf --dmenu | cliphist decode | wl-copy"
	),
	{ description = "Utilities: Clipboard history >> clipboard" }
)
hl.bind(
	"SUPER + Period",
	hl.dsp.exec_cmd(qsIsAlive .. " || pkill fuzzel || " .. hyprScripts .. "/fuzzel-emoji.sh copy"),
	{ description = "Utilities: Emoji >> clipboard" }
)
hl.bind("SUPER + SHIFT + S", hl.dsp.global("quickshell:regionScreenshot"), { description = "Utilities: Screen snip" })
hl.bind(
	"SUPER + SHIFT + S",
	hl.dsp.exec_cmd(qsIsAlive .. " || pidof slurp || hyprshot --freeze --clipboard-only --mode region --silent")
)
hl.bind("SUPER + SHIFT + A", hl.dsp.global("quickshell:regionSearch"), { description = "Utilities: Google Lens" })
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd(qsIsAlive .. " || pidof slurp || " .. hyprScripts .. "/snip_to_search.sh"))
--# OCR
hl.bind(
	"SUPER + SHIFT + X",
	hl.dsp.global("quickshell:regionOcr"),
	{ description = "Utilities: Character recognition >> clipboard" }
)
hl.bind(
	"SUPER + SHIFT + T",
	hl.dsp.global("quickshell:screenTranslate"),
	{ description = "Utilities: Translate screen content" }
)
hl.bind(
	"SUPER + SHIFT + X",
	hl.dsp.exec_cmd(
		qsIsAlive
			.. " || pidof slurp || grim -g \"$(slurp $SLURP_ARGS)\" \"/tmp/ocr_image.png\" && tesseract \"/tmp/ocr_image.png\" stdout -l $(tesseract --list-langs | awk 'NR>1{print $1}' | tr '\\\\n' '+' | sed 's/\\\\+$/\\\\n/') | wl-copy && rm \"/tmp/ocr_image.png\""
	)
)
--# Color picker
hl.bind(
	"SUPER + SHIFT + C",
	hl.dsp.exec_cmd("hyprpicker -a"),
	{ description = "Utilities: Pick color #RRGGBB >> clipboard" }
)

hl.bind(
	"SUPER + SHIFT + R",
	hl.dsp.global("quickshell:regionRecord"),
	{ locked = true, description = "Utilities: Record region (no sound)" }
)
hl.bind(
	"SUPER + SHIFT + R",
	hl.dsp.exec_cmd(qsIsAlive .. " || " .. qsScripts .. "/videos/record.sh"),
	{ locked = true }
)
hl.bind("SUPER + ALT + R", hl.dsp.global("quickshell:regionRecord"), { locked = true })
hl.bind("SUPER + ALT + R", hl.dsp.exec_cmd(qsIsAlive .. " || " .. qsScripts .. "/videos/record.sh"), { locked = true })
hl.bind("CTRL + ALT + R", hl.dsp.exec_cmd(qsScripts .. "/videos/record.sh --fullscreen"), { locked = true })
hl.bind(
	"SUPER + SHIFT + ALT + R",
	hl.dsp.exec_cmd(qsScripts .. "/videos/record.sh --fullscreen --sound"),
	{ locked = true, description = "Utilities: Record screen (with sound)" }
)
--# Fullscreen screenshot
local grimhyprctl = "grim -o \"$(hyprctl activeworkspace -j | jq -r '.monitor')\""
hl.bind(
	"Print",
	hl.dsp.exec_cmd(grimhyprctl .. " - | wl-copy"),
	{ locked = true, description = "Utilities: Screenshot >> clipboard" }
)
hl.bind(
	"CTRL + Print",
	hl.dsp.exec_cmd(
		"mkdir -p $(xdg-user-dir PICTURES)/Screenshots && "
			.. grimhyprctl
			.. " $(xdg-user-dir PICTURES)/Screenshots/Screenshot_\"$(date '+%Y-%m-%d_%H.%M.%S')\".png"
	),
	{ locked = true, non_consuming = true, description = "Utilities: Screenshot >> clipboard & file" }
)
hl.bind("CTRL + Print", hl.dsp.exec_cmd(grimhyprctl .. " - | wl-copy"), { locked = true, non_consuming = true })

--##! Screen
--# Zoom
local function zoomfunction(value)
	local zoomvalue = hl.get_config("cursor:zoom_factor")
	if (zoomvalue + value) > 3.0 then
		hl.config({ cursor = { zoom_factor = 3.0 } })
	elseif (zoomvalue + value) < 1.0 then
		hl.config({ cursor = { zoom_factor = 1.0 } })
	else
		hl.config({ cursor = { zoom_factor = zoomvalue + value } })
	end
end
hl.bind("SUPER + mouse_up", function()
	zoomfunction(-0.3)
end, { repeating = true, description = "Screen: Zoom out" })
hl.bind("SUPER + mouse_down", function()
	zoomfunction(0.3)
end, { repeating = true, description = "Screen: Zoom in" })

--##! Media
local mediaNextCommand =
	'playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`'
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd(mediaNextCommand), { locked = true, description = "Media: Next track" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(mediaNextCommand), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("SUPER + SHIFT + ALT + mouse:275", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("SUPER + SHIFT + ALT + mouse:276", hl.dsp.exec_cmd(mediaNextCommand))
hl.bind(
	"SUPER + SHIFT + B",
	hl.dsp.exec_cmd("playerctl previous"),
	{ locked = true, description = "Media: Previous track" }
)
hl.bind(
	"SUPER + SHIFT + P",
	hl.dsp.exec_cmd("playerctl play-pause"),
	{ locked = true, description = "Media: Play/pause media" }
)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"), { locked = true })
hl.bind(
	"SUPER + SHIFT + M",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"),
	{ locked = true, description = "Media: Toggle mute" }
)
hl.bind("ALT + XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { locked = true })
hl.bind(
	"SUPER + ALT + M",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"),
	{ locked = true, description = "Media: Toggle mic" }
)

--#!
--##! Window
--# Focusing
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Window: Move" })
hl.bind("SUPER + mouse:274", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Window: Resize" })
--#/# bind = SUPER + ←/↑/→/↓,, -- Focus in direction
for i = 1, 4 do
	local arrowkey = { "Left", "Right", "Up", "Down" }
	local focusdir = { "l", "r", "u", "d" }
	hl.bind(
		"SUPER + " .. arrowkey[i],
		hl.dsp.focus({ direction = focusdir[i] }),
		{ description = "Window: Focus " .. arrowkey[i] }
	)
end
for i = 1, 2 do
	local arrowkey = { "BracketLeft", "BracketRight" }
	local focusdir = { "l", "r" }
	hl.bind("SUPER + " .. arrowkey[i], hl.dsp.focus({ direction = focusdir[i] }))
end
--#/# bind = SUPER + SHIFT, ←/↑/→/↓,, -- Move in direction
for i = 1, 4 do
	local arrowkey = { "Left", "Right", "Up", "Down" }
	local focusdir = { "l", "r", "u", "d" }
	hl.bind(
		"SUPER + SHIFT + " .. arrowkey[i],
		hl.dsp.window.move({ direction = focusdir[i] }),
		{ description = "Window: Move " .. arrowkey[i] }
	)
end

hl.bind("ALT + F4", function()
	hl.exec_cmd('notify-send "Wrong close keybind" "Super+Q to close. Use Alt+F4 for Windows VMs" -a Hyprland')
end, { non_consuming = true })
hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Window: Close" })
hl.bind("SUPER + SHIFT + ALT + Q", hl.dsp.exec_cmd("hyprctl kill"), { description = "Window: Forcefully zap a window" })

--# Window split ratio
--#/# binde = SUPER, ;/',, -- Adjust split ratio
hl.bind("SUPER + Semicolon", hl.dsp.layout("splitratio -0.1"), { repeating = true })
hl.bind("SUPER + Apostrophe", hl.dsp.layout("splitratio +0.1"), { repeating = true })
--# Positioning mode
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }), { description = "Window: Float/Tile" })
hl.bind(
	"SUPER + D",
	hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }),
	{ description = "Window: Maximize" }
)
hl.bind(
	"SUPER + F",
	hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
	{ description = "Window: Fullscreen" }
)
hl.bind(
	"SUPER + ALT + F",
	hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" }),
	{ description = "Window: Fullscreen spoof" }
)
hl.bind("SUPER + P", hl.dsp.window.pin(), { description = "Window: Pin" })

--#/# bind = SUPER+ALT, Hash,, -- Send to workspace -- (1, 2, 3,...)
for i = 1, 10 do
	hl.bind("SUPER + ALT + " .. (i % 10), function()
		hl.dispatch(hl.dsp.window.move({ workspace = i, follow = false }))
	end, { description = "Window: Send to workspace " .. i })
end

--##! Workspace
--# Switching
--#/# bind = SUPER, Hash,, -- Focus workspace -- (1, 2, 3,...)
for i = 1, 10 do
	hl.bind("SUPER + " .. (i % 10), function()
		hl.dispatch(hl.dsp.focus({ workspace = i }))
	end, { description = "Workspace: Focus " .. i })
end
--## Special
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("special"), { description = "Workspace: Toggle scratchpad" })
hl.bind("SUPER + mouse:275", hl.dsp.workspace.toggle_special("special"))
for i = 1, 4 do
	local key = { "BracketLeft", "BracketRight", "Up", "Down" }
	local prefix = { "-1", "+1", "r-5", "r+5" }
	hl.bind("CTRL + SUPER + " .. key[i], hl.dsp.focus({ workspace = prefix[i] }))
end
hl.bind(
	"SUPER + ALT + S",
	hl.dsp.window.move({ workspace = "special:special", follow = false }),
	{ description = "Window: Send to scratchpad" }
)
hl.bind("CTRL + SUPER + S", hl.dsp.workspace.toggle_special("special"))

--##! Session
hl.bind("SUPER + L", hl.dsp.exec_cmd("loginctl lock-session"), { description = "Session: Lock" })

--##! Apps
hl.bind("SUPER + T", hl.dsp.exec_cmd(terminal), { description = "Apps: Terminal" })
hl.bind("SUPER + E", hl.dsp.exec_cmd(fileManager), { description = "Apps: File Manager" })
hl.bind("SUPER + W", hl.dsp.exec_cmd(browser), { description = "Apps: Browser" })
hl.bind("SUPER + X", hl.dsp.exec_cmd(editor), { description = "Apps: Text Editor" })
hl.bind("CTRL + SHIFT + ESCAPE", hl.dsp.exec_cmd(taskManager), { description = "Apps: Task Manager" })

