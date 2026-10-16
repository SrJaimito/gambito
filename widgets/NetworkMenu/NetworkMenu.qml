import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.SlidingMenu
import qs.components.Label
import qs.components.Toggle
import qs.services.Network


SlidingMenu {
    id: root

    open: UserControl.networkMenuIsVisible
    onCloseRequested: UserControl.networkMenuIsVisible = false

    // Scanning drains battery, so only keep the list fresh while it's shown
    onOpenChanged: Network.setScanning(root.open)

    alignRight: true
    straightSide: true

    // A minimum width keeps the menu from resizing as networks come and go
    contentWidth: Math.max(content.implicitWidth, 250)
    contentHeight: content.implicitHeight

    WrapperItem {
        id: content

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        leftMargin: LookAndFeel.spacing.tiny
        rightMargin: LookAndFeel.spacing.small
        topMargin: LookAndFeel.spacing.small
        bottomMargin: LookAndFeel.spacing.small

        ColumnLayout {
            spacing: LookAndFeel.spacing.tiny

            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: LookAndFeel.spacing.small

                Label {
                    Layout.fillWidth: true

                    text: "Wifi"
                }

                Toggle {
                    checked: Network.wifiEnabled
                    handler: enabled => Network.setWifiEnabled(enabled)
                }
            }

            // Separate the wifi switch from the connections list
            Rectangle {
                Layout.fillWidth: true
                Layout.topMargin: LookAndFeel.spacing.tiny
                Layout.bottomMargin: LookAndFeel.spacing.tiny
                implicitHeight: 2

                radius: LookAndFeel.rounding.full

                color: LookAndFeel.color.surface_2
            }

            NetworkRow {
                Layout.fillWidth: true

                visible: Network.wiredHasLink && Network.wiredNetwork !== null

                icon: "\u{f0200}"
                name: "Ethernet"
                connected: Network.wiredNetwork?.connected ?? false
                busy: Network.wiredNetwork?.stateChanging ?? false

                onClicked: Network.toggle(Network.wiredNetwork)
            }

            Repeater {
                model: Network.wifiEnabled ? Network.knownWifiNetworks : []

                delegate: NetworkRow {
                    required property var modelData

                    Layout.fillWidth: true

                    icon: ""
                    name: modelData.name
                    connected: modelData.connected
                    busy: modelData.stateChanging

                    onClicked: Network.toggle(modelData)
                }
            }

            Label {
                Layout.leftMargin: LookAndFeel.spacing.small

                visible: Network.wifiEnabled && Network.knownWifiNetworks.length === 0

                text: "No known networks in range"
                color: LookAndFeel.color.overlay_0
            }
        }
    }
}
