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

    // Accent color, stored as a palette name so it follows the light/dark mode
    readonly property color barHighlightColor: LookAndFeel.color[root.highlightColor]

    function setDarkMode(darkMode: bool) {
        settings.darkMode = darkMode;
    }

    function setHighlightColor(name: string) {
        settings.highlightColor = name;
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
        }
    }
}
