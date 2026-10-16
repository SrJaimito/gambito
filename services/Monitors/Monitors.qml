pragma Singleton


import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

import QtQuick

import qs.config


Singleton {
    id: root

    // Connected monitors, with their size in logical pixels (the unit Hyprland
    // positions monitors in): divided by the scale and swapped when rotated
    readonly property var monitors: Hyprland.monitors.values.map(m => {
        const transform = m.lastIpcObject.transform ?? 0;
        // Not known until the monitors are first refreshed
        const scale = m.scale > 0 ? m.scale : 1;
        const width = Math.round(m.width / scale);
        const height = Math.round(m.height / scale);
        const rotated = transform % 2 === 1;

        return {
            name: m.description,
            connector: m.name,
            x: m.x,
            y: m.y,
            width: rotated ? height : width,
            height: rotated ? width : height,
            resolution: `${m.width}x${m.height}`,
            scale: scale,
            transform: transform,
        };
    })

    // Saved layout for the connected set of monitors, if any
    readonly property var currentLayout: {
        const key = UserConfig.layoutKey(root.monitors.map(m => m.name));
        return UserConfig.monitorLayouts.find(l => UserConfig.layoutKey(l.monitors.map(m => m.name)) === key) ?? null;
    }

    // Monitor holding the main bar and the menus: the saved choice while it
    // is connected, the first monitor otherwise
    readonly property string primaryName: {
        const saved = root.currentLayout?.primaryMonitor;
        if (saved && root.monitors.some(m => m.name === saved)) {
            return saved;
        }

        return root.monitors[0]?.name ?? "";
    }

    readonly property ShellScreen primaryScreen: {
        const connector = root.monitors.find(m => m.name === root.primaryName)?.connector;
        return Quickshell.screens.find(s => s.name === connector) ?? Quickshell.screens[0];
    }

    // Move the monitors to the given positions ([{ name, x, y, transform }],
    // in logical pixels) and save them as the layout for this set of monitors
    function applyPositions(positions) {
        root.move(positions);

        UserConfig.setMonitorLayout({
            monitors: positions.map(p => ({ name: p.name, transform: p.transform, x: p.x, y: p.y })),
            primaryMonitor: root.primaryName,
        });
    }

    // Save a new primary monitor, keeping the saved positions or, without
    // any, the current ones
    function setPrimary(name) {
        UserConfig.setMonitorLayout({
            monitors: root.currentLayout?.monitors
                ?? root.monitors.map(m => ({ name: m.name, transform: m.transform, x: m.x, y: m.y })),
            primaryMonitor: name,
        });
    }

    function move(positions) {
        // Monitors are matched by description, as connector names can change
        // between plugs. Strings are escaped to be quoted in Lua
        const quote = (s) => `"${s.replace(/\\/g, "\\\\").replace(/"/g, "\\\"")}"`;

        const calls = positions.map(p => {
            const scale = root.monitors.find(m => m.name === p.name)?.scale ?? 1;
            return `hl.monitor({ output = ${quote("desc:" + p.name)}, mode = "preferred", `
                 + `position = "${p.x}x${p.y}", scale = ${scale}, transform = ${p.transform} })`;
        });

        hyprctl.command = ["hyprctl", "eval", calls.join("\n")];
        hyprctl.running = true;
    }

    // Move the monitors to their saved layout unless they are already there
    function restoreLayout() {
        const layout = root.currentLayout;
        if (!layout) {
            return;
        }

        const moved = layout.monitors.some(saved => {
            const live = root.monitors.find(m => m.name === saved.name);
            return !live || live.x !== saved.x || live.y !== saved.y || live.transform !== saved.transform;
        });

        if (moved) {
            root.move(layout.monitors);
        }
    }

    Process {
        id: hyprctl

        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text.trim() !== "ok") {
                    console.warn("Monitors: hyprctl eval failed:", this.text.trim());
                }
            }
        }

        // Positions are only reported again after asking for them
        onExited: Hyprland.refreshMonitors()
    }

    // Monitors come and go in bursts while plugging, so wait for things to
    // settle before reading them and restoring the matching layout. This also
    // runs at startup to override the positions given in Hyprland's config
    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name.startsWith("monitoradded") || event.name.startsWith("monitorremoved")) {
                settle.restart();
            }
        }
    }

    Timer {
        id: settle

        interval: 500
        running: true

        onTriggered: {
            Hyprland.refreshMonitors();
            restore.restart();
        }
    }

    // Descriptions and transforms only arrive with the refresh above
    Timer {
        id: restore

        interval: 300

        onTriggered: root.restoreLayout()
    }
}
