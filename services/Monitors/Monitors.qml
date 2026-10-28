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

    // Monitors in workspace order: the primary one first, then the rest left
    // to right and top to bottom. The i-th one gets workspace i
    readonly property var workspaceOrder: {
        const others = root.monitors
            .filter(m => m.name !== root.primaryName)
            .sort((a, b) => a.x - b.x || a.y - b.y);
        const primary = root.monitors.filter(m => m.name === root.primaryName);
        return primary.concat(others).map(m => m.name);
    }

    onWorkspaceOrderChanged: workspaceDebounce.restart()

    // Quotes a string for Lua
    function quote(s) {
        return `"${s.replace(/\\/g, "\\\\").replace(/"/g, "\\\"")}"`;
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
        // between plugs
        const calls = positions.map(p => {
            const scale = root.monitors.find(m => m.name === p.name)?.scale ?? 1;
            return `hl.monitor({ output = ${root.quote("desc:" + p.name)}, mode = "preferred", `
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

    // Pin workspace i to the i-th monitor of workspaceOrder, with rules for
    // when it's created later and moving it there if it already exists
    function applyWorkspaces() {
        const order = root.workspaceOrder;
        if (order.length === 0) {
            return;
        }

        // Rules can't be removed, only disabled, so keep their handles in a
        // Lua global (it survives between evals) and reuse them, or every
        // call would add another copy
        const calls = [
            "gambito_ws_rules = gambito_ws_rules or {}",
            "for _, r in pairs(gambito_ws_rules) do r:set_enabled(false) end",
            "local function pin(ws, mon) "
                + "local key = ws .. '|' .. mon "
                + "if gambito_ws_rules[key] then gambito_ws_rules[key]:set_enabled(true) "
                + "else gambito_ws_rules[key] = hl.workspace_rule({ workspace = ws, monitor = mon, default = true }) end "
                + "end",
        ];

        order.forEach((name, i) => {
            const workspace = `"${i + 1}"`;
            const output = root.quote("desc:" + name);
            calls.push(`pin(${workspace}, ${output})`);

            const connector = root.monitors.find(m => m.name === name)?.connector;
            const existing = Hyprland.workspaces.values.find(w => w.id === i + 1);
            if (existing && existing.monitor?.name !== connector) {
                calls.push(`hl.dispatch(hl.dsp.workspace.move({ workspace = ${workspace}, monitor = ${output} }))`);
            }
        });

        workspaceCtl.command = ["hyprctl", "eval", calls.join("\n")];
        workspaceCtl.running = true;
    }

    // Separate from hyprctl so a layout move in flight isn't overwritten
    Process {
        id: workspaceCtl

        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text.trim() !== "ok") {
                    console.warn("Monitors: workspace hyprctl eval failed:", this.text.trim());
                }
            }
        }
    }

    // The order flips through intermediate values while monitors and the
    // saved layout load, so only act once it has settled
    Timer {
        id: workspaceDebounce

        interval: 300

        onTriggered: root.applyWorkspaces()
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
            } else if (event.name === "configreloaded") {
                // Reloading drops the rules added at runtime
                workspaceDebounce.restart();
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

        onTriggered: {
            root.restoreLayout();
            // Workspaces may have been left on the wrong monitor by the plug
            workspaceDebounce.restart();
        }
    }
}
