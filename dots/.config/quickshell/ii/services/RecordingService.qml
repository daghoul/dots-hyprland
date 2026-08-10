pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool isRecording: false
    property bool stopped: false
    property int elapsedSeconds: 0 // Used for recording indicator

    Timer {
        id: incrementTimer
        interval: 1000
        running: root.isRecording && !root.stopped
        repeat: true
        onTriggered: {
            root.elapsedSeconds += 1
        }
    }

    property string pidFilePath: {
        var runtimeDir = Quickshell.env("XDG_RUNTIME_DIR")
        console.log("XDG_RUNTIME_DIR:", runtimeDir)
        if (runtimeDir) {
            var path = runtimeDir + "/wf-recorder.pid"
            return path
        } else {
            return "/tmp/wf-recorder.pid"
        }
    }

    FileView {
        id: pidFileView
        path: root.pidFilePath
        watchChanges: true

        onFileChanged: {
            checkProc.running = true;
        }

        Component.onCompleted: {
            // Check on startup in case a recording is already active
            checkProc.running = true;
        }
    }

    Process {
        id: checkProc
        command: ["bash", "-c",
            "pidfile=\"" + root.pidFilePath + "\"; " +
            "if [ -f \"$pidfile\" ]; then " +
                "pid=$(cat \"$pidfile\" 2>/dev/null); " +
                "if kill -0 $pid 2>/dev/null; then " +
                    "echo \"1 $(ps -o etimes= -p $pid 2>/dev/null | tr -d ' ')\"; " +
                "else echo 0; fi " +
            "else echo 0; fi"
        ]
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = text.trim().split(/\s+/);
                const isRec = (parts[0] === "1");
                const elapsed = parseInt(parts[1]) || 0;

                if (isRec && !root.isRecording) {
                    root.elapsedSeconds = elapsed;
                    root.isRecording = true;
                    root.stopped = false;
                } else if (!isRec && root.isRecording) {
                    root.isRecording = false;
                    root.stopped = true;
                    root.elapsedSeconds = 0;
                } else if (isRec && root.isRecording) {
                    // Sync elapsed time to correct any drift
                    root.elapsedSeconds = elapsed;
                }
            }
        }
        stderr: StdioCollector {
            onStreamFinished: {
                if (text.length > 0)
                    console.warn("[RecordingService] stderr:", text);
            }
        }
    }

    function stopRecording() {
        Quickshell.execDetached(["bash", "-c", "pkill wf-recorder"]);
    }
}