pragma Singleton

import qs.modules.common
import qs.modules.common.functions
import QtQuick
import Quickshell
import Quickshell.Io

/*
 * System updates service. Currently only supports Arch.
 */
Singleton {
    id: root

    property bool available: false
    property alias checking: checkUpdatesProc.running
    property int count: 0
    // property var details: []
    
    readonly property bool updateAdvised: available && count > Config.options.updates.adviseUpdateThreshold
    readonly property bool updateStronglyAdvised: available && count > Config.options.updates.stronglyAdviseUpdateThreshold

    property string pkgManager: "pacman"

    function load() {}
    function refresh() {
        if (checking || !available) return;
        print("[Updates] Checking for updates...");
        checkUpdatesProc.running = true;
    }

    // function fetchDetails() {
    //     if (count === 0) {
    //         details = [];
    //         return;
    //     }
    //     // Set the command on the detail process and start it
    //     let cmd;
    //     if (pkgManager === "pacman") {
    //         cmd = ["bash", "-c", "pacman -Qu 2>/dev/null"];
    //     } else {
    //         cmd = ["bash", "-c", pkgManager + " -Qu 2>/dev/null"];
    //     }
    //     detailProc.command = cmd;
    //     detailProc.running = true;
    // }

    function performUpdate() {
        let term = Config.options.apps.terminal;
        let updateCmd = pkgManager === "pacman"
            ? "sudo pacman -Syu"
            : pkgManager + " -Syu";
        
        // Build the full command as a shell string
        let fullCmd = term + " -e " + updateCmd;
        
        console.log("[Updates] Running:", fullCmd);
        Quickshell.execDetached(["bash", "-c", fullCmd]);
    }

    Timer {
        interval: Config.options.updates.checkInterval * 60 * 1000
        repeat: true
        running: Config.ready && Config.options.updates.enableCheck
        onTriggered: {
            print("[Updates] Periodic update check due")
            root.refresh();
        }
    }

    Process {
        id: checkAvailabilityProc
        running: Config.ready && Config.options.updates.enableCheck
        command: ["which", "checkupdates"]
        onExited: (exitCode, exitStatus) => {
            root.available = (exitCode === 0);
            root.refresh();
        }
    }

    Process {
        id: checkUpdatesProc
        command: ["bash", "-c", "checkupdates | wc -l"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.count = parseInt(text.trim()) || 0;
                // print("[Updates] Found", root.count, "updates");
                // if (root.count > 0) root.fetchDetails();
                // else root.details = [];
            }
        }
    }

    // Process {
    //     id: detailProc
    //     stdout: StdioCollector {
    //         onStreamFinished: {
    //             const lines = text.trim().split("\n").filter(l => l.length > 0);
    //             root.details = lines.map(line => {
    //                 const parts = line.split(/\s+/);
    //                 // Format: package old-version -> new-version
    //                 let newVersion = "";
    //                 if (parts.length >= 4 && parts[2] === "->") {
    //                     // The new version is after the arrow
    //                     newVersion = parts[3] || "";
    //                 } else if (parts.length >= 3) {
    //                     // Fallback: no arrow (maybe `pacman -Qu` without arrow?)
    //                     newVersion = parts[2] || "";
    //                 }
    //                 // Clean up extra text like [16h13m]
    //                 newVersion = newVersion.replace(/\[.*\]$/, "").trim();
    //                 return {
    //                     name: parts[0],
    //                     oldVersion: parts[1] || "",
    //                     newVersion: newVersion
    //                 };
    //             });
    //         }
    //     }
    // }

    Process {
        id: detectParuProc
        command: ["which", "paru"]
        onExited: (code, status) => {
            if (code === 0) {
                root.pkgManager = "paru";
            } else {
                detectYayProc.running = true;
            }
        }
    }

    Process {
        id: detectYayProc
        command: ["which", "yay"]
        onExited: (code, status) => {
            if (code === 0) {
                root.pkgManager = "yay";
            }
            // else stays "pacman"
        }
    }

    // Component.onCompleted: {
    //     // Detect package manager first
    //     detectParuProc.running = true;
    //     // Then check availability and refresh
    //     checkAvailabilityProc.running = true;
    // }
}
