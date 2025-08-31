import Quickshell

import QtQuick

import qs.widgets.Bar
import qs.widgets.MainMenu


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

    color: "transparent"

    mask: Region {
        x: 0
        y: bar.height
        width: root.width
        height: root.height - bar.height

        intersection: Intersection.Xor

        regions: widgetRegions.instances
    }

    Variants {
        id: widgetRegions

        model: [bar, mainMenu]

        Region {
            required property Item modelData

            x: modelData.x
            y: modelData.y
            width: modelData.width
            height: modelData.height

            intersection: Intersection.Subtract
        }
    }

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
        id: mainMenu

        bar: bar
        z: -10
    }
}

