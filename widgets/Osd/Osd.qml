import Quickshell
import Quickshell.Wayland

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

import qs.config
import qs.components.Label
import qs.services.Audio
import qs.services.Brightness


// Pops up whenever the volume or the screen brightness changes. It doesn't
// care about key presses: the Hyprland bindings keep running wpctl and
// brightnessctl, and this only watches the values they change, so changes made
// from anywhere else show up too
PanelWindow {
    id: root

    required property int shadowMargin

    // What the OSD shows, "volume" or "brightness"
    property string kind: "volume"
    property bool shown: false

    // Values settle in when the shell starts or the output device changes,
    // which isn't the user changing anything
    property bool ready: false

    readonly property int value: root.kind === "volume" ? Audio.getVolume() : Brightness.brightness
    readonly property bool muted: root.kind === "volume" && Audio.isMuted

    function show(kind) {
        if (!root.ready) {
            return;
        }

        root.kind = kind;
        root.shown = true;
        hideTimer.restart();
    }

    // Without anchors on the sides the compositor centers it horizontally
    anchors.bottom: true
    margins.bottom: (root.screen?.height ?? 0) * 0.15 - root.shadowMargin

    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    // We make the window bigger than its body to have room for its shadow
    implicitWidth: body.width + 2 * root.shadowMargin
    implicitHeight: body.height + 2 * root.shadowMargin

    // and let every click through, it's only there to be looked at
    mask: Region {}

    // Stay mapped until the fade out is over
    visible: root.shown || body.opacity > 0

    color: "transparent"

    Timer {
        id: hideTimer

        interval: 1500
        onTriggered: root.shown = false
    }

    Timer {
        id: settleTimer

        interval: 1000
        running: true
        onTriggered: root.ready = true
    }

    Connections {
        target: Audio

        function onSinkChanged() {
            root.ready = false;
            settleTimer.restart();
        }
    }

    Connections {
        target: Audio.sink?.audio ?? null

        function onVolumeChanged() {
            // The audio menu has its own slider for this
            if (!UserControl.audioMenuIsVisible) {
                root.show("volume");
            }
        }

        function onMutedChanged() {
            root.show("volume");
        }
    }

    Connections {
        target: Brightness

        function onBrightnessChanged() {
            root.show("brightness");
        }
    }

    Rectangle {
        id: body

        width: row.implicitWidth + 2 * LookAndFeel.spacing.normal
        height: row.implicitHeight + 2 * LookAndFeel.spacing.small

        anchors.centerIn: parent
        // Rise a little while fading in
        anchors.verticalCenterOffset: root.shown ? 0 : LookAndFeel.spacing.small

        radius: LookAndFeel.rounding.full

        color: LookAndFeel.color.base

        opacity: root.shown ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }

        Behavior on anchors.verticalCenterOffset {
            NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "black"
        }

        RowLayout {
            id: row

            anchors.centerIn: parent

            spacing: LookAndFeel.spacing.small

            Label {
                // Fixed width so switching icons doesn't shift the bar
                Layout.preferredWidth: LookAndFeel.fontSize.large * 1.5

                horizontalAlignment: Text.AlignHCenter

                fontFamily: LookAndFeel.fontFamily.propo
                fontSize: LookAndFeel.fontSize.large

                text: {
                    if (root.kind === "brightness") {
                        return "";
                    }

                    if (root.muted) {
                        return "";
                    }

                    if (root.value < 33) {
                        return "";
                    } else if (root.value < 66) {
                        return "";
                    } else {
                        return "";
                    }
                }
            }

            Rectangle {
                id: track

                implicitWidth: 200
                implicitHeight: 5

                radius: LookAndFeel.rounding.full

                color: LookAndFeel.color.surface_1

                Rectangle {
                    height: parent.height
                    width: parent.width * Math.min(Math.max(root.value, 0), 100) / 100

                    radius: LookAndFeel.rounding.full

                    color: root.muted ? LookAndFeel.color.overlay_0 : UserConfig.barHighlightColor

                    Behavior on width {
                        NumberAnimation { duration: 100 }
                    }
                }
            }

            Label {
                // Wide enough for "100%" so the pill doesn't resize
                Layout.preferredWidth: textMetrics.width

                horizontalAlignment: Text.AlignRight

                text: root.value + "%"

                TextMetrics {
                    id: textMetrics

                    font.family: LookAndFeel.fontFamily.propo
                    font.pixelSize: LookAndFeel.fontSize.normal
                    text: "100%"
                }
            }
        }
    }
}
