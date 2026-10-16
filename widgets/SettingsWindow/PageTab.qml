import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.Label


WrapperMouseArea {
    id: root

    required property string icon
    required property string title
    required property bool selected

    margin: 0

    enabled: true
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    Rectangle {
        implicitWidth: row.implicitWidth + 2 * LookAndFeel.spacing.small
        implicitHeight: row.implicitHeight + LookAndFeel.spacing.tiny * 2

        radius: LookAndFeel.rounding.full

        color: root.selected ? UserConfig.barHighlightColor
             : root.containsMouse ? LookAndFeel.color.surface_0
             : "transparent"

        RowLayout {
            id: row

            anchors.centerIn: parent

            spacing: LookAndFeel.spacing.tiny

            Label {
                text: root.icon
                fontFamily: LookAndFeel.fontFamily.propo
                color: root.selected ? LookAndFeel.color.crust : UserConfig.barHighlightColor
            }

            Label {
                text: root.title
                color: root.selected ? LookAndFeel.color.crust : LookAndFeel.color.text
            }
        }
    }
}
