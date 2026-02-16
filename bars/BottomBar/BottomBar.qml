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

    // We make the bar bigger to be able to draw sides and cast shadows
    implicitHeight: sideBorderWidth + sideLength + LookAndFeel.spacing.normal
    // but later we reserve space for the actual bottom border only
    exclusiveZone: sideBorderWidth

    // We must, however, make the part above the actual border non-clickable
    mask: Region {
        item: clickthrough_mask
        intersection: Intersection.Xor
    }

    Rectangle {
        id: clickthrough_mask

        width: root.width - 2 * root.sideBorderWidth
        height: root.height - root.sideBorderWidth

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        color: "transparent"
    }

    color: "transparent"

    Shape {
        bar: parent

        sideBorderWidth: root.sideBorderWidth
        sideLength: root.sideLength
        sideAngle: root.sideAngle
    }
}

