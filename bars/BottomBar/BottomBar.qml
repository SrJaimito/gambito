import Quickshell

import QtQuick

import qs.config


PanelWindow {
    id: root

    required property int length
    required property double angle

    anchors {
        bottom: true
        left: true
        right: true
    }

    exclusiveZone: height / 2

    color: "transparent"

    Shape {
        bar: parent
        screenBorder: height / 2
        length: root.length
        angle: root.angle
    }
}

