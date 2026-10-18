pragma Singleton


import Quickshell
import Quickshell.Io

import QtQuick


// Chooses the wallpaper; hyprpaper draws it. hyprpaper reads a fixed path,
// which we keep as a symlink to the chosen picture
Singleton {
    id: root

    // Pictures offered to choose from
    readonly property string folder: Quickshell.env("HOME") + "/Pictures/Wallpapers"
    // Path hyprpaper's config points to
    readonly property string linkPath: Quickshell.env("HOME") + "/.config/current_wallpaper"

    // Picture the link currently points to
    property string current: ""

    function set(path: string) {
        root.current = path;

        // The link path doesn't change, so hyprpaper can't tell the picture
        // did: tell it to show the link again. Paths go in as positional
        // arguments so they need no quoting
        apply.command = [
            "sh", "-c", 'ln -sfn "$1" "$2" && hyprctl hyprpaper wallpaper ",$2"',
            "sh", path, root.linkPath,
        ];
        apply.running = true;
    }

    // Read the link at startup, it may have been changed outside the shell
    Process {
        running: true
        command: ["readlink", "-f", root.linkPath]

        stdout: StdioCollector {
            onStreamFinished: root.current = this.text.trim()
        }
    }

    Process {
        id: apply

        stdout: StdioCollector {
            onStreamFinished: {
                const reply = this.text.trim();
                if (reply !== "" && reply !== "ok") {
                    console.warn("Wallpaper: hyprpaper replied:", reply);
                }
            }
        }

        onExited: (exitCode) => {
            if (exitCode !== 0) {
                console.warn("Wallpaper: setting the wallpaper failed with exit code", exitCode);
            }
        }
    }
}
