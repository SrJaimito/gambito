pragma Singleton


import Quickshell
import Quickshell.Io

import QtQuick


// Screen backlight, read straight from sysfs. Whoever changes it (brightnessctl
// from the Hyprland key bindings, logind...), the kernel's backlight core
// notifies actual_brightness, which wakes the file watcher below
Singleton {
    id: root

    // First backlight device found, empty if there is none (e.g. a desktop)
    property string device: ""
    readonly property bool available: device !== "" && maxBrightness > 0

    property int maxBrightness: 0
    property int rawBrightness: 0

    // Percentage on brightnessctl's -e4 curve, the one the key bindings step
    // through, so every key press moves it by the same 5%. A linear percentage
    // would crawl at the bottom and jump at the top
    readonly property int brightness: available
        ? Math.round(Math.pow(rawBrightness / maxBrightness, 1 / 4) * 100)
        : 0

    // There's no directory listing in QML, so ask ls once at startup
    Process {
        running: true
        command: ["ls", "/sys/class/backlight"]

        stdout: StdioCollector {
            onStreamFinished: root.device = text.split("\n")[0].trim()
        }
    }

    FileView {
        path: root.device ? "/sys/class/backlight/" + root.device + "/max_brightness" : ""

        onLoaded: root.maxBrightness = parseInt(text())
    }

    FileView {
        path: root.device ? "/sys/class/backlight/" + root.device + "/actual_brightness" : ""

        watchChanges: true
        onFileChanged: reload()

        onLoaded: root.rawBrightness = parseInt(text())
    }
}
