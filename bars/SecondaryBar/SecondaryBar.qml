import Quickshell
import Quickshell.Hyprland

import QtQuick

import qs.config
import qs.modules.Workspaces


Item {
    id: root

    // Screen whose workspaces are shown
    required property ShellScreen screen

    required property int barHeight
    required property int topBorderWidth

    required property int topAngle

    required property int topGroupTransitionRadius

    readonly property int padding: LookAndFeel.spacing.small

    Shape {
        bar: parent

        barHeight: root.barHeight
        topBorderWidth: root.topBorderWidth

        groupWidth: workspaces.width

        topAngle: root.topAngle

        topGroupTransitionRadius: root.topGroupTransitionRadius
    }

    Item {
        implicitHeight: root.barHeight

        anchors {
            left: parent.left
            top: parent.top
        }

        Workspaces {
            id: workspaces

            monitor: Hyprland.monitorFor(root.screen)

            // No distro logo covering the left side, so round it too
            leftMargin: root.padding

            topLeftRadius: LookAndFeel.rounding.full
            bottomLeftRadius: LookAndFeel.rounding.full

            // Like the main bar, the group width leaves out this margin
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: root.padding
            }
        }
    }
}
