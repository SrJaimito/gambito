import Quickshell

import QtQuick

import qs.config


PanelWindow {
    id: root

    required property int sideBorderWidth
    required property int sideLength
    required property int sideAngle

    anchors {
        bottom: true
        left: true
        right: true
    }

    implicitHeight: sideBorderWidth + sideLength + LookAndFeel.spacing.normal
    exclusiveZone: sideBorderWidth

    color: "transparent"

    Shape {
        bar: parent

        sideBorderWidth: root.sideBorderWidth
        sideLength: root.sideLength
        sideAngle: root.sideAngle
    }
}

