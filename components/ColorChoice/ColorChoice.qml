import QtQuick

import qs.config


// A row of swatches to pick one of the palette colors by name
Grid {
    id: root

    // Names of the LookAndFeel.color entries to offer
    required property list<string> names
    // Currently chosen name, kept in sync with the outside world
    required property string selected
    // Called with the name of the swatch the user clicks
    required property var handler

    property int swatchWidth: 22

    spacing: LookAndFeel.spacing.tiny

    Repeater {
        model: root.names

        delegate: Rectangle {
            id: ring

            required property string modelData

            readonly property bool isSelected: modelData === root.selected

            // Room around the swatch for the selection ring
            implicitWidth: root.swatchWidth + 8
            implicitHeight: implicitWidth

            radius: LookAndFeel.rounding.full

            color: "transparent"
            border.width: 2
            border.color: ring.isSelected ? LookAndFeel.color.text
                        : swatchArea.containsMouse ? LookAndFeel.color.surface_2
                        : "transparent"

            Rectangle {
                anchors.centerIn: parent

                width: root.swatchWidth
                height: root.swatchWidth

                radius: LookAndFeel.rounding.full

                color: LookAndFeel.color[ring.modelData]
            }

            MouseArea {
                id: swatchArea

                anchors.fill: parent

                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: root.handler(ring.modelData)
            }
        }
    }
}
