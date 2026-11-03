import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

import QtQuick

import qs.config


// Region screenshot, started by the "gambito:screenshot" global shortcut
// (bound in the Hyprland config with hl.dsp.global). The focused monitor is
// frozen into a still frame, a resizable rectangle selects the region, Enter
// saves it as a PNG and copies it to the clipboard, Esc cancels
Scope {
    id: root

    required property int shadowMargin

    readonly property string directory: Quickshell.env("HOME") + "/Pictures/Screenshots"

    // Monitor being captured, fixed when the shortcut is pressed so it doesn't
    // follow the focus while dragging
    property ShellScreen targetScreen: null

    // Path of the last saved screenshot
    property string lastPath: ""

    function start() {
        if (UserControl.screenshotIsActive) {
            return;
        }

        const name = Hyprland.focusedMonitor?.name;
        root.targetScreen = Quickshell.screens.find(s => s.name === name) ?? Quickshell.screens[0];

        // Make sure the directory exists by the time the region is confirmed
        mkdir.running = true;

        UserControl.screenshotIsActive = true;
    }

    function saved(path) {
        root.lastPath = path;
        UserControl.screenshotIsActive = false;

        wlCopy.command = ["sh", "-c", "wl-copy --type image/png < \"$1\"", "sh", path];
        wlCopy.running = true;
    }

    GlobalShortcut {
        appid: "gambito"
        name: "screenshot"
        description: "Take a screenshot of a region of the focused monitor"

        onPressed: root.start()
    }

    Process {
        id: mkdir

        command: ["mkdir", "-p", root.directory]
    }

    Process {
        id: wlCopy

        onExited: (code) => {
            if (code !== 0) {
                console.warn("Screenshot: wl-copy failed with exit code", code);
            }
            toast.show(code === 0);
        }
    }

    LazyLoader {
        active: UserControl.screenshotIsActive

        PanelWindow {
            id: window

            screen: root.targetScreen

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            WlrLayershell.namespace: "gambito-screenshot"

            color: "transparent"

            // Physical pixels per logical pixel, so the PNG has the monitor's
            // native resolution instead of the logical one
            readonly property real scale: root.targetScreen?.devicePixelRatio ?? 1

            readonly property int minSize: 16

            // Selection in logical pixels, starting centered at half the screen
            property real selX: width / 4
            property real selY: height / 4
            property real selW: width / 2
            property real selH: height / 2

            function clamp(v, lo, hi) {
                return Math.min(Math.max(v, lo), hi);
            }

            // Moves the edges a handle owns (ex/ey: -1 left/top, 1 right/bottom,
            // 0 untouched; both 0 moves the whole rectangle) by the drag offset
            // from where it started. Edges stop minSize short of the opposite
            // one instead of flipping the rectangle
            function applyDrag(ex, ey, start, dx, dy) {
                if (ex === 0 && ey === 0) {
                    window.selX = clamp(start.x + dx, 0, window.width - start.w);
                    window.selY = clamp(start.y + dy, 0, window.height - start.h);
                    return;
                }

                let left = start.x;
                let top = start.y;
                let right = start.x + start.w;
                let bottom = start.y + start.h;

                if (ex < 0) {
                    left = clamp(left + dx, 0, right - window.minSize);
                } else if (ex > 0) {
                    right = clamp(right + dx, left + window.minSize, window.width);
                }

                if (ey < 0) {
                    top = clamp(top + dy, 0, bottom - window.minSize);
                } else if (ey > 0) {
                    bottom = clamp(bottom + dy, top + window.minSize, window.height);
                }

                window.selX = left;
                window.selY = top;
                window.selW = right - left;
                window.selH = bottom - top;
            }

            function capture() {
                const path = root.directory + "/Screenshot_"
                    + Qt.formatDateTime(new Date(), "yyyy-MM-dd_HH-mm-ss") + ".png";
                const size = Qt.size(Math.round(window.selW * window.scale), Math.round(window.selH * window.scale));

                const ok = selection.grabToImage(result => {
                    if (result.saveToFile(path)) {
                        root.saved(path);
                    } else {
                        console.warn("Screenshot: couldn't save", path);
                        UserControl.screenshotIsActive = false;
                    }
                }, size);

                if (!ok) {
                    console.warn("Screenshot: couldn't grab the selection");
                    UserControl.screenshotIsActive = false;
                }
            }

            Item {
                id: content

                anchors.fill: parent

                focus: true

                // The window is mapped before the frame arrives, so it stays
                // empty until then and the overlay never ends up in the shot
                opacity: frozen.hasContent ? 1 : 0

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        window.capture();
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Escape) {
                        UserControl.screenshotIsActive = false;
                        event.accepted = true;
                    }
                }

                ScreencopyView {
                    id: frozen

                    anchors.fill: parent

                    captureSource: root.targetScreen
                    live: false
                    paintCursor: false
                }

                Rectangle {
                    anchors.fill: parent

                    color: LookAndFeel.color.crust
                    opacity: 0.5
                }

                // The undimmed region, and also what gets saved: a copy of the
                // frozen frame shifted so only the selection shows through.
                // grabToImage only renders this item's subtree, so the border
                // and handles drawn over it aren't in the PNG
                Item {
                    id: selection

                    x: window.selX
                    y: window.selY
                    width: window.selW
                    height: window.selH

                    clip: true

                    ShaderEffectSource {
                        x: -window.selX
                        y: -window.selY
                        width: frozen.width
                        height: frozen.height

                        sourceItem: frozen
                        // Full native resolution, the item itself is logical
                        textureSize: Qt.size(Math.round(frozen.width * window.scale), Math.round(frozen.height * window.scale))
                    }
                }

                Rectangle {
                    x: window.selX - border.width
                    y: window.selY - border.width
                    width: window.selW + 2 * border.width
                    height: window.selH + 2 * border.width

                    color: "transparent"
                    border.width: 2
                    border.color: UserConfig.barHighlightColor
                }

                // Before the handles so they win where they overlap
                MouseArea {
                    property var start
                    property point origin

                    x: window.selX
                    y: window.selY
                    width: window.selW
                    height: window.selH

                    cursorShape: Qt.SizeAllCursor

                    onPressed: mouse => {
                        start = { x: window.selX, y: window.selY, w: window.selW, h: window.selH };
                        origin = mapToItem(content, mouse.x, mouse.y);
                    }

                    onPositionChanged: mouse => {
                        const p = mapToItem(content, mouse.x, mouse.y);
                        window.applyDrag(0, 0, start, p.x - origin.x, p.y - origin.y);
                    }
                }

                Repeater {
                    model: [
                        { ex: -1, ey: -1, cursor: Qt.SizeFDiagCursor },
                        { ex: 0, ey: -1, cursor: Qt.SizeVerCursor },
                        { ex: 1, ey: -1, cursor: Qt.SizeBDiagCursor },
                        { ex: 1, ey: 0, cursor: Qt.SizeHorCursor },
                        { ex: 1, ey: 1, cursor: Qt.SizeFDiagCursor },
                        { ex: 0, ey: 1, cursor: Qt.SizeVerCursor },
                        { ex: -1, ey: 1, cursor: Qt.SizeBDiagCursor },
                        { ex: -1, ey: 0, cursor: Qt.SizeHorCursor },
                    ]

                    delegate: MouseArea {
                        id: handle

                        required property var modelData

                        property var start
                        property point origin

                        // Bigger than the dot so it's easy to grab
                        width: 24
                        height: 24

                        x: window.selX + (modelData.ex + 1) / 2 * window.selW - width / 2
                        y: window.selY + (modelData.ey + 1) / 2 * window.selH - height / 2

                        cursorShape: modelData.cursor

                        onPressed: mouse => {
                            start = { x: window.selX, y: window.selY, w: window.selW, h: window.selH };
                            origin = mapToItem(content, mouse.x, mouse.y);
                        }

                        onPositionChanged: mouse => {
                            const p = mapToItem(content, mouse.x, mouse.y);
                            window.applyDrag(modelData.ex, modelData.ey, start, p.x - origin.x, p.y - origin.y);
                        }

                        Rectangle {
                            anchors.centerIn: parent

                            width: 12
                            height: 12

                            radius: LookAndFeel.rounding.full

                            color: UserConfig.barHighlightColor
                            border.width: 2
                            border.color: LookAndFeel.color.base
                        }
                    }
                }
            }
        }
    }

    Toast {
        id: toast

        screen: root.targetScreen
        shadowMargin: root.shadowMargin
    }
}
