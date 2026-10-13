import QtQuick

import qs.config


Item {
    id: root

    // Current state, kept in sync with the outside world
    required property bool checked
    // Called with the new state when the user clicks the switch
    required property var handler

    property int toggleWidth: 44
    property int toggleHeight: 24

    implicitWidth: root.toggleWidth
    implicitHeight: root.toggleHeight

    Rectangle {
        id: track

        anchors.fill: parent

        radius: LookAndFeel.rounding.full

        color: root.checked ? UserConfig.barHighlightColor : LookAndFeel.color.surface_0

        Rectangle {
            id: knob

            readonly property int padding: 3

            anchors.verticalCenter: parent.verticalCenter

            width: track.height - 2 * knob.padding
            height: width

            x: root.checked ? track.width - width - knob.padding : knob.padding

            radius: LookAndFeel.rounding.full

            color: root.checked ? LookAndFeel.color.crust
                 : mouseArea.containsMouse ? LookAndFeel.color.overlay_2
                 : LookAndFeel.color.overlay_0

            Behavior on x {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: root.handler(!root.checked)
    }
}
