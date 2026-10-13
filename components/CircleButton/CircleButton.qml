import Quickshell
import Quickshell.Widgets

import QtQuick
import QtQuick.Shapes

import qs.config
import qs.components.Label


WrapperMouseArea {
    id: root

    property alias text: label.text
    
    property color fgColor: LookAndFeel.color.crust
    property color bgColor: UserConfig.barHighlightColor
    property color fgColorHover: UserConfig.barHighlightColor
    property color bgColorHover: LookAndFeel.color.surface_0

    property real radialPadding: LookAndFeel.spacing.small

    margin: 0

    enabled: true
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    Item {
        id: item

        readonly property real diag: Math.sqrt(label.width * label.width + label.height * label.height) / 2

        implicitWidth: diag + root.radialPadding
        implicitHeight: diag + root.radialPadding

        Shape {
            anchors.fill: parent

            layer.enabled: true
            layer.samples: 6

            ShapePath {
                id: circle

                fillColor: root.containsMouse ? root.bgColorHover : root.bgColor
                strokeWidth: -1

                startX: 0
                startY: item.height / 2

                PathArc {
                    relativeX: 0
                    relativeY: 0.00001
                    radiusX: item.height / 2
                    radiusY: item.height / 2
                    useLargeArc: true
                }
            }
        }

        Label {
            id: label

            anchors.centerIn: parent

            color: root.containsMouse ? root.fgColorHover : root.fgColor
        }
    }
}

