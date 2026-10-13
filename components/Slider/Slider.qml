import Quickshell

import QtQuick

import qs.config


Item {
    id: root

    // Current value in [0, 100], kept in sync with the outside world
    required property real value
    // Called with the new value in [0, 100] while the user drags the circle
    required property var handler

    property int sliderWidth: 150
    property int circleWidth: 15

    implicitWidth: sliderBar.implicitWidth + sliderCircle.implicitWidth
    implicitHeight: sliderCircle.implicitHeight

    Rectangle {
        id: sliderBar

        anchors.centerIn: parent

        implicitWidth: root.sliderWidth
        implicitHeight: 5

        radius: LookAndFeel.rounding.full

        color: LookAndFeel.color.surface_0
    }

    Rectangle {
        id: sliderCircle

        anchors.verticalCenter: parent.verticalCenter

        implicitWidth: root.circleWidth
        implicitHeight: root.circleWidth

        radius: LookAndFeel.rounding.full

        color: LookAndFeel.color.surface_0

        // Follow the value except while being dragged, so external changes
        // move the circle without fighting the drag
        Binding on x {
            when: !mouseArea.drag.active
            value: (root.width - sliderCircle.width) * Math.min(Math.max(root.value, 0), 100) / 100
            restoreMode: Binding.RestoreNone
        }

        onXChanged: {
            if (mouseArea.drag.active) {
                root.handler(x * 100 / (root.width - width));
            }
        }

        Rectangle {
            id: sliderCircleHover

            visible: mouseArea.containsMouse || mouseArea.drag.active

            anchors.centerIn: parent

            width: parent.width / 2
            height: parent.height / 2

            radius: LookAndFeel.rounding.full

            color: UserConfig.barHighlightColor
        }

        MouseArea {
            id: mouseArea

            anchors.fill: parent

            enabled: true
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            drag.target: sliderCircle
            drag.axis: Drag.XAxis
            drag.minimumX: 0
            drag.maximumX: root.width - sliderCircle.width
            drag.smoothed: false
            drag.threshold: 0
        }
    }
}

