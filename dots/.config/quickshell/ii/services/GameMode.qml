pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs.modules.common.models.hyprland
import qs.modules.common

Singleton {
    id: root

    function load() {}

    readonly property bool anyFullscreen: Hyprland.workspaces.values.some(ws =>
        ws.active && ws.toplevels.values.some(t => t.wayland?.fullscreen))

    readonly property bool engaged: Config.options.gameMode.active
        || (Config.options.gameMode.autoOnFullscreen && root.anyFullscreen)

    function setManual(on) {
        if (on === root.engaged) return;
        Config.options.gameMode.active = on;
    }

    readonly property bool visualEngaged: root.engaged && Config.options.gameMode.visual
    onVisualEngagedChanged: root.applyVisual(visualEngaged)
    function applyVisual(on) {
        if (on) {
            HyprlandConfig.setMany({
                "animations:enabled": 0,
                "decoration:shadow:enabled": 0,
                "decoration:blur:enabled": 0,
                "general:gaps_in": 0,
                "general:gaps_out": 0,
                "general:border_size": 1,
                "decoration:rounding": 0,
                "general:allow_tearing": 1
            });
        } else {
            HyprlandConfig.resetMany([ //
                "animations:enabled", //
                "decoration:shadow:enabled", //
                "decoration:blur:enabled", //
                "general:gaps_in", //
                "general:gaps_out", //
                "general:border_size", //
                "decoration:rounding", //
                "general:allow_tearing", //
            ]);
        }
    }

    Process {
        running: root.engaged && Config.options.gameMode.system
        command: ["gamemoderun", "sleep", "infinity"]
    }

    // readonly property bool wallpaperPaused: root.engaged && Config.options.gameMode.wallpaper
    // onWallpaperPausedChanged: root.setWallpaperPaused(wallpaperPaused)
    // function setWallpaperPaused(paused) {
    //    Quickshell.execDetached(["bash", "-c",
    //        `"$HOME/.config/hypr/custom/scripts/video-wallpaper-power.sh" ${paused ? "stop" : "cont"}`])
    //}

    Component.onCompleted: {
        if (root.visualEngaged) root.applyVisual(true);
        // if (root.wallpaperPaused) root.setWallpaperPaused(true);
    }
}