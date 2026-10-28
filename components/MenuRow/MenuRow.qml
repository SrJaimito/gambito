import Quickshell.Widgets

import QtQuick

import qs.config
import qs.components.Info


// A clickable entry for menu lists (networks, audio outputs), highlighted
// like TextButton while active
WrapperMouseArea {
    id: root

    // Optional, rows without one show just the name
    property string icon: ""
    required property string name
    required property bool active
    // Changing state (e.g. connecting), shown dimmed until it settles
    required property bool busy

    margin: 0

    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    Rectangle {
        implicitWidth: info.implicitWidth + 2 * LookAndFeel.spacing.small
        implicitHeight: info.implicitHeight + 2 * LookAndFeel.spacing.tiny

        radius: LookAndFeel.rounding.full

        color: root.active && !root.containsMouse ? UserConfig.barHighlightColor
             : root.containsMouse ? LookAndFeel.color.surface_0
             : "transparent"

        Info {
            id: info

            anchors {
                left: parent.left
                leftMargin: LookAndFeel.spacing.small
                verticalCenter: parent.verticalCenter
            }

            readonly property color textColor: root.busy ? LookAndFeel.color.overlay_0
                : root.active && !root.containsMouse ? LookAndFeel.color.crust
                : root.active ? UserConfig.barHighlightColor
                : LookAndFeel.color.text

            icon: root.icon
            iconVisible: root.icon !== ""
            info: root.name

            iconColor: textColor
            infoColor: textColor
        }
    }
}
