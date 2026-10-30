import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.Label
import qs.services.Clock
import qs.services.Notifications


// One notification in the list. Clicking it runs its default action and marks
// it read, the cross only marks it read
MouseArea {
    id: root

    required property var notification

    // How long ago it arrived, refreshed every minute
    readonly property string age: {
        const received = Notifications.receivedAt[root.notification.id];
        if (!received) {
            return "";
        }

        const minutes = Math.floor((Clock.date - received) / 60000);
        if (minutes < 1) {
            return "now";
        } else if (minutes < 60) {
            return minutes + "m";
        } else if (minutes < 24 * 60) {
            return Math.floor(minutes / 60) + "h";
        } else {
            return Qt.formatDateTime(new Date(received), "MMM d");
        }
    }

    implicitHeight: row.implicitHeight + 2 * LookAndFeel.spacing.small

    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    onClicked: Notifications.invoke(root.notification)

    Rectangle {
        anchors.fill: parent

        radius: LookAndFeel.rounding.small

        color: root.containsMouse ? LookAndFeel.color.surface_0 : LookAndFeel.color.base
    }

    RowLayout {
        id: row

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            leftMargin: LookAndFeel.spacing.small
            rightMargin: LookAndFeel.spacing.small
        }

        spacing: LookAndFeel.spacing.small

        // Only the notification's own image (e.g. an avatar), the app's icon
        // is already in the group header
        IconImage {
            Layout.alignment: Qt.AlignTop

            visible: root.notification.image !== ""

            implicitSize: 32
            source: root.notification.image
        }

        ColumnLayout {
            Layout.fillWidth: true

            spacing: 0

            RowLayout {
                Layout.fillWidth: true

                Label {
                    Layout.fillWidth: true

                    elide: Text.ElideRight
                    font.bold: true
                    text: root.notification.summary
                }

                Label {
                    fontSize: LookAndFeel.fontSize.normal * 0.8
                    text: root.age
                    color: LookAndFeel.color.overlay_1
                }
            }

            Label {
                Layout.fillWidth: true

                visible: text !== ""

                wrapMode: Text.Wrap
                maximumLineCount: 3
                elide: Text.ElideRight
                textFormat: Text.StyledText
                text: root.notification.body
                color: LookAndFeel.color.subtext_1
            }
        }

        MouseArea {
            id: close

            Layout.alignment: Qt.AlignTop

            implicitWidth: cross.implicitWidth
            implicitHeight: cross.implicitHeight

            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: Notifications.dismiss(root.notification)

            Label {
                id: cross

                text: "\u{f0156}"
                color: close.containsMouse ? LookAndFeel.color.red : LookAndFeel.color.overlay_1
            }
        }
    }
}
