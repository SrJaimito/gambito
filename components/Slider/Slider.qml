import Quickshell

import QtQuick

import qs.config


Item {
    id: root

    required property var handler

    property int sliderWidth: 150
    property int circleWidth: 15
    property int initPosition: 0

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
        x: (root.width - width) / 100 * root.initPosition

        implicitWidth: root.circleWidth
        implicitHeight: root.circleWidth

        radius: LookAndFeel.rounding.full

        color: LookAndFeel.color.surface_0

        onXChanged: {
            handler(x * 100 / (root.width - width));
        }

        Rectangle {
            id: sliderCircleHover

            visible: false

            anchors.centerIn: parent

            width: parent.width / 2
            height: parent.height / 2

            radius: LookAndFeel.rounding.full

            color: UserConfig.barHighlightColor
        }

        MouseArea {
            anchors.fill: parent

            enabled: true
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onEntered: {
                sliderCircleHover.visible = true;
            }

            onExited: {
                sliderCircleHover.visible = false;
            }

            drag.target: sliderCircle
            drag.axis: Drag.XAxis
            drag.minimumX: 0
            drag.maximumX: root.width - sliderCircle.width
            drag.smoothed: false
            drag.threshold: 0
        }
    }
}

