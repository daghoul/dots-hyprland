hl.on("hyprland.start", function()
	-- Necessary
	hl.exec_cmd("qs -c $qsConfig")

	-- Essential Programs
	hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
	hl.exec_cmd("pidof hypridle || hypridle")
	hl.exec_cmd("pidof hyprsunset || hyprsunset")

	-- Yes
	hl.exec_cmd("dbus-update-activation-environment --all")
	hl.exec_cmd("sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

	hl.exec_cmd(
		"wl-paste --type text --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'"
	)
	hl.exec_cmd(
		"wl-paste --type image --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'"
	)

	-- For alacritty
	hl.exec_cmd("alacritty --daemon")
end)
