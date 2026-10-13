import Quickshell
import Quickshell.Widgets

import QtQuick

import qs.config


PanelWindow {
    id: root

    required property int barHeight

    readonly property bool open: UserControl.mainMenuIsVisible

    anchors {
        top: true
        left: true
    }

    // Sit right below the bar instead of being pushed by its exclusive zone
    exclusionMode: ExclusionMode.Ignore
    margins.top: barHeight

    implicitWidth: content.width
    implicitHeight: content.height

    // Only mapped while open or sliding out, see the animation below
    visible: false
    onOpenChanged: if (open) visible = true

    color: "transparent"

    Item {
        id: content

        implicitWidth: buttons.implicitWidth + 10
        implicitHeight: buttons.implicitHeight

        // Slide in from the left edge of the screen
        x: root.open ? 0 : -width

        Shape {
            container: content
        }

        WrapperItem {
            id: buttons

            anchors.verticalCenter: parent.verticalCenter

            leftMargin: LookAndFeel.spacing.small
            rightMargin: LookAndFeel.spacing.small
            topMargin: LookAndFeel.spacing.tiny
            bottomMargin: LookAndFeel.spacing.tiny

            Buttons {
                spacing: LookAndFeel.spacing.small
            }
        }

        Behavior on x {
            NumberAnimation {
                duration: 500
                easing.type: Easing.OutQuad
                onStopped: {
                    if (!root.open) {
                        root.visible = false;
                    }
                }
            }
        }
    }
}
