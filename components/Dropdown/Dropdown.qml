import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.Label


// A button showing the chosen option that unfolds the list of options below
// it. The list is drawn over whatever follows, so give the dropdown (or the
// row holding it) a z above its later siblings
Item {
    id: root

    required property list<string> options
    // Currently chosen option, kept in sync with the outside world
    required property string selected
    // Called with the option the user clicks
    required property var handler

    property bool expanded: false

    implicitWidth: button.implicitWidth
    implicitHeight: button.implicitHeight

    // Fold back when pressing anywhere else in the window. The press still
    // reaches whatever is under it, so it doesn't take an extra click
    MouseArea {
        id: outsideCatcher

        parent: root.Window.contentItem
        anchors.fill: parent

        z: 1000
        visible: root.expanded

        onPressed: (mouse) => {
            const inList = list.contains(outsideCatcher.mapToItem(list, mouse.x, mouse.y));
            const inButton = button.contains(outsideCatcher.mapToItem(button, mouse.x, mouse.y));
            if (!inList && !inButton) {
                root.expanded = false;
            }

            mouse.accepted = false;
        }
    }

    // Start folded the next time the window is shown
    Connections {
        target: root.Window.window

        function onVisibleChanged() {
            root.expanded = false;
        }
    }

    WrapperMouseArea {
        id: button

        margin: 0

        enabled: true
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: root.expanded = !root.expanded

        Rectangle {
            implicitWidth: buttonRow.implicitWidth + 2 * LookAndFeel.spacing.small
            implicitHeight: buttonRow.implicitHeight + 2 * LookAndFeel.spacing.tiny

            radius: LookAndFeel.rounding.full

            color: button.containsMouse || root.expanded ? LookAndFeel.color.surface_1 : LookAndFeel.color.surface_0

            RowLayout {
                id: buttonRow

                anchors.centerIn: parent

                spacing: LookAndFeel.spacing.small

                Label {
                    text: root.selected
                }

                Label {
                    text: root.expanded ? "" : ""
                    fontFamily: LookAndFeel.fontFamily.propo
                    color: UserConfig.barHighlightColor
                }
            }
        }
    }

    Rectangle {
        id: list

        // Unfold below the button, lined up with its right edge as dropdowns
        // sit on the right side of their rows
        anchors {
            top: button.bottom
            topMargin: LookAndFeel.spacing.tiny
            right: button.right
        }

        z: 1
        visible: root.expanded

        implicitWidth: Math.max(listColumn.implicitWidth, button.width) + 2 * LookAndFeel.spacing.tiny
        implicitHeight: listColumn.implicitHeight + 2 * LookAndFeel.spacing.tiny

        radius: LookAndFeel.rounding.small

        color: LookAndFeel.color.mantle
        border.width: 1
        border.color: LookAndFeel.color.surface_0

        ColumnLayout {
            id: listColumn

            anchors {
                fill: parent
                margins: LookAndFeel.spacing.tiny
            }

            spacing: 0

            Repeater {
                model: root.options

                delegate: WrapperMouseArea {
                    id: option

                    required property string modelData

                    readonly property bool isSelected: modelData === root.selected

                    Layout.fillWidth: true

                    margin: 0

                    enabled: true
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        root.expanded = false;
                        root.handler(option.modelData);
                    }

                    Rectangle {
                        implicitWidth: optionLabel.implicitWidth + 2 * LookAndFeel.spacing.small
                        implicitHeight: optionLabel.implicitHeight + 2 * LookAndFeel.spacing.tiny

                        radius: LookAndFeel.rounding.small

                        color: option.containsMouse ? UserConfig.barHighlightColor : "transparent"

                        Label {
                            id: optionLabel

                            anchors {
                                left: parent.left
                                leftMargin: LookAndFeel.spacing.small
                                verticalCenter: parent.verticalCenter
                            }

                            text: option.modelData
                            color: option.containsMouse ? LookAndFeel.color.crust
                                 : option.isSelected ? UserConfig.barHighlightColor
                                 : LookAndFeel.color.text
                        }
                    }
                }
            }
        }
    }
}
