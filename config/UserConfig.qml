pragma Singleton


import Quickshell
import Quickshell.Io

import QtQuick


Singleton {
    id: root

    // Stored choices, saved to a JSON file in the shell's data directory.
    // Change them through the setters below so they get written to disk
    readonly property alias darkMode: settings.darkMode
    readonly property alias highlightColor: settings.highlightColor
    // Monitor arrangements, one per set of connected monitors. See setMonitorLayout
    readonly property alias monitorLayouts: settings.monitorLayouts

    // Accent color, stored as a palette name so it follows the light/dark mode
    readonly property color barHighlightColor: LookAndFeel.color[root.highlightColor]

    function setDarkMode(darkMode: bool) {
        settings.darkMode = darkMode;
    }

    function setHighlightColor(name: string) {
        settings.highlightColor = name;
    }

    // Store a layout ({ monitors: [{ name, transform, x, y }], primaryMonitor }),
    // replacing the one saved for the same set of monitor names if any
    function setMonitorLayout(layout) {
        const key = layoutKey(layout.monitors.map(m => m.name));
        const layouts = settings.monitorLayouts.filter(l => layoutKey(l.monitors.map(m => m.name)) !== key);
        layouts.push(layout);

        // Assign a new array, mutating the old one wouldn't notify the adapter
        settings.monitorLayouts = layouts;
    }

    // Identifies a set of monitors regardless of their order
    function layoutKey(names) {
        return names.slice().sort().join("\n");
    }

    FileView {
        path: Quickshell.dataPath("settings.json")

        // Load before the bars are created so they start with the stored values
        blockLoading: true

        // Pick up hand edits to the file
        watchChanges: true
        onFileChanged: reload()

        // Save every change made through the setters
        onAdapterUpdated: writeAdapter()

        // Create the file with the defaults on first run
        onLoadFailed: (error) => {
            if (error === FileViewError.FileNotFound) {
                writeAdapter();
            }
        }

        JsonAdapter {
            id: settings

            property bool darkMode: true
            property string highlightColor: "maroon"
            property var monitorLayouts: []
        }
    }
}
