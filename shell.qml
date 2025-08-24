import Quickshell

import QtQuick

import qs.widgets.Bar


PanelWindow {
    id: root

    readonly property int barHeight: 40

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: screen.height
    exclusiveZone: barHeight

    mask: Region {
        item: Rectangle {
            anchors {
                left: root.left
                right: root.right
                bottom: root.bottom
            }

            height: root.height - root.barHeight
        }
    }

    color: "transparent"

    Bar {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        implicitHeight: root.barHeight
    }
}

