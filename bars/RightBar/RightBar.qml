import Quickshell

import QtQuick


PanelWindow {
    id: root

    required property int length
    required property double angle

    anchors {
        top: true
        right: true
        bottom: true
    }

    exclusiveZone: width / 2

    color: "transparent"

    Shape {
        bar: parent
        screenBorder: width / 2
        length: root.length
        angle: root.angle
    }
}

