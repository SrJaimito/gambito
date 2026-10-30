import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.SlidingMenu
import qs.components.Label
import qs.components.TextButton
import qs.services.Notifications


// The unread notifications, grouped by app. Opened from the notification tray
SlidingMenu {
    id: root

    open: UserControl.notificationMenuIsVisible
    onCloseRequested: UserControl.notificationMenuIsVisible = false

    straightSide: true

    // Taller lists scroll instead of running off the screen
    readonly property real maxHeight: (root.screen?.height ?? 1000) * 0.6

    contentWidth: 400
    contentHeight: Math.min(list.implicitHeight + 2 * LookAndFeel.spacing.small, root.maxHeight)

    // Nothing left to show, and the tray that opened it is gone
    Connections {
        target: Notifications

        function onUnreadChanged() {
            if (Notifications.unread.length === 0) {
                UserControl.notificationMenuIsVisible = false;
            }
        }
    }

    Flickable {
        id: flickable

        anchors {
            fill: parent
            leftMargin: LookAndFeel.spacing.small
            rightMargin: LookAndFeel.spacing.tiny
            topMargin: LookAndFeel.spacing.small
            bottomMargin: LookAndFeel.spacing.small
        }

        clip: true
        contentHeight: list.implicitHeight
        boundsBehavior: Flickable.StopAtBounds

        ColumnLayout {
            id: list

            width: flickable.width

            spacing: LookAndFeel.spacing.small

            RowLayout {
                Layout.fillWidth: true

                Label {
                    Layout.fillWidth: true

                    font.bold: true
                    text: "Notifications"
                }

                TextButton {
                    text: "Clear all"
                    onClicked: Notifications.clearAll()
                }
            }

            Repeater {
                model: Notifications.apps

                delegate: ColumnLayout {
                    id: app

                    required property var modelData

                    Layout.fillWidth: true

                    spacing: LookAndFeel.spacing.tiny

                    RowLayout {
                        Layout.fillWidth: true

                        spacing: LookAndFeel.spacing.tiny

                        IconImage {
                            visible: app.modelData.icon !== ""

                            implicitSize: LookAndFeel.fontSize.normal
                            source: app.modelData.icon
                        }

                        Label {
                            Layout.fillWidth: true

                            elide: Text.ElideRight
                            text: app.modelData.appName
                            color: LookAndFeel.color.overlay_1
                        }
                    }

                    Repeater {
                        model: app.modelData.notifications

                        delegate: Card {
                            required property var modelData

                            Layout.fillWidth: true

                            notification: modelData
                        }
                    }
                }
            }
        }
    }
}
