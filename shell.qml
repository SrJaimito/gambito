import Quickshell

import QtQuick

import qs.widgets.Bar
import qs.widgets.MainMenu
import qs.components.CircleButton


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
        x: 0
        y: bar.height
        width: root.width
        height: root.height - bar.height

        intersection: Intersection.Xor
    }

    color: "transparent"

    Bar {
        id: bar

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        implicitHeight: root.barHeight
    }

    MainMenu {
        bar: bar
        z: -10
    }
}

