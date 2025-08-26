import Quickshell
import Quickshell.Widgets

import QtQuick
import QtQuick.Shapes

import qs.config
import qs.components.Label


WrapperMouseArea {
    id: root

    property alias text: label.text
    
    property string fgColor: LookAndFeel.color.crust
    property string bgColor: UserConfig.barHighlightColor

    property real radialPadding: 15

    margin: 0

    enabled: true
    hoverEnabled: true

    onEntered: {
        label.color = root.bgColor;
        circle.fillColor = root.fgColor;
    }

    onExited: {
        label.color = root.fgColor;
        circle.fillColor = root.bgColor;
    }

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

                fillColor: root.bgColor
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

            color: root.fgColor
        }
    }
}

