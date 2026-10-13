import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.Label


// A setting: its title and description on the left, the control that
// changes it (given as the child) on the right
RowLayout {
    id: root

    required property string title
    property string description: ""

    default property alias control: controlSlot.data

    spacing: LookAndFeel.spacing.normal

    ColumnLayout {
        Layout.fillWidth: true

        spacing: 0

        Label {
            Layout.fillWidth: true

            text: root.title
        }

        Label {
            Layout.fillWidth: true

            visible: root.description !== ""

            text: root.description
            wrapMode: Text.WordWrap
            fontSize: LookAndFeel.fontSize.normal - 3
            color: LookAndFeel.color.subtext_0
        }
    }

    Item {
        id: controlSlot

        Layout.alignment: Qt.AlignVCenter

        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
    }
}
