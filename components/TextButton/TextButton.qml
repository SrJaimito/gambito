import Quickshell.Widgets

import QtQuick

import qs.config
import qs.components.Label


// A pill-shaped button with a text label, colored like CircleButton
WrapperMouseArea {
    id: root

    property alias text: label.text

    margin: 0

    hoverEnabled: true
    cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

    Rectangle {
        implicitWidth: label.implicitWidth + 2 * LookAndFeel.spacing.normal
        implicitHeight: label.implicitHeight + 2 * LookAndFeel.spacing.tiny

        radius: LookAndFeel.rounding.full

        color: !root.enabled ? LookAndFeel.color.surface_0
             : root.containsMouse ? LookAndFeel.color.surface_0
             : UserConfig.barHighlightColor

        Label {
            id: label

            anchors.centerIn: parent

            color: !root.enabled ? LookAndFeel.color.overlay_0
                 : root.containsMouse ? UserConfig.barHighlightColor
                 : LookAndFeel.color.crust
        }
    }
}
