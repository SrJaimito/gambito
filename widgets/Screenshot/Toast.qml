import Quickshell
import Quickshell.Wayland

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

import qs.config
import qs.components.Label


// Click-through pill near the bottom confirming a screenshot, styled like the
// Osd but shown on the monitor that was captured rather than the primary one
PanelWindow {
    id: root

    required property int shadowMargin

    property bool shown: false
    property bool copied: false

    function show(copied) {
        root.copied = copied;
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
                fontSize: LookAndFeel.fontSize.large
                color: UserConfig.barHighlightColor

                text: ""
            }

            Label {
                text: root.copied ? "Screenshot saved and copied" : "Screenshot saved"
            }
        }
    }
}
