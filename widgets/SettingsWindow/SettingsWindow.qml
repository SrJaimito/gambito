import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

import qs.config
import qs.components.CircleButton


PanelWindow {
    id: root

    required property int shadowMargin

    // Every page of the window, in the order their tabs are shown. Adding a
    // page means creating its file in this directory and listing it here
    readonly property var pages: [
        { title: "Appearance", icon: "\uee26", source: "AppearancePage.qml" },
    ]

    // Kept across openings so the window reopens where it was left
    property int currentPage: 0

    // A layer surface without anchors is centered on its screen by the
    // compositor, floating above everything without reserving space
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    // We make the window bigger than its body to have room for its shadow
    implicitWidth: body.width + 2 * root.shadowMargin
    implicitHeight: body.height + 2 * root.shadowMargin

    // but only the body itself takes clicks
    mask: Region {
        item: body
    }

    visible: UserControl.settingsWindowIsVisible

    color: "transparent"

    // Close when clicking anywhere outside the window
    HyprlandFocusGrab {
        active: root.visible
        windows: [root]

        onCleared: UserControl.settingsWindowIsVisible = false
    }

    Rectangle {
        id: body

        // Fixed size so switching pages doesn't resize and re-center the window
        width: 700
        height: 500

        anchors.centerIn: parent

        radius: LookAndFeel.rounding.normal

        color: LookAndFeel.color.base

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "black"
        }

        focus: true
        Keys.onEscapePressed: UserControl.settingsWindowIsVisible = false

        ColumnLayout {
            anchors {
                fill: parent
                margins: LookAndFeel.spacing.normal
            }

            spacing: LookAndFeel.spacing.normal

            RowLayout {
                Layout.fillWidth: true

                spacing: LookAndFeel.spacing.small

                Repeater {
                    model: root.pages

                    delegate: PageTab {
                        required property var modelData
                        required property int index

                        icon: modelData.icon
                        title: modelData.title
                        selected: index === root.currentPage

                        onClicked: root.currentPage = index
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                CircleButton {
                    text: ""
                    onClicked: UserControl.settingsWindowIsVisible = false
                }
            }

            // Separate the tabs from the page
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 2

                radius: LookAndFeel.rounding.full

                color: LookAndFeel.color.surface_2
            }

            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true

                contentHeight: page.height
                boundsBehavior: Flickable.StopAtBounds
                clip: true

                Loader {
                    id: page

                    width: parent.width

                    source: root.pages[root.currentPage].source
                }
            }
        }
    }
}
