import Quickshell.Widgets

import QtQuick

import qs.config
import qs.components.Info


// A clickable network entry, highlighted like TextButton while connected
WrapperMouseArea {
    id: root

    required property string icon
    required property string name
    required property bool connected
    // Connecting or disconnecting, shown dimmed until it settles
    required property bool busy

    margin: 0

    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    Rectangle {
        implicitWidth: info.implicitWidth + 2 * LookAndFeel.spacing.small
        implicitHeight: info.implicitHeight + 2 * LookAndFeel.spacing.tiny

        radius: LookAndFeel.rounding.full

        color: root.connected && !root.containsMouse ? UserConfig.barHighlightColor
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
                : root.connected && !root.containsMouse ? LookAndFeel.color.crust
                : root.connected ? UserConfig.barHighlightColor
                : LookAndFeel.color.text

            icon: root.icon
            info: root.name

            iconColor: textColor
            infoColor: textColor
        }
    }
}
