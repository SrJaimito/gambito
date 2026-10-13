import Quickshell
import Quickshell.Hyprland

import QtQuick

import qs.config
import qs.modules.Workspaces


PanelWindow {
    id: root

    required property int barHeight
    required property int topBorderWidth

    required property int topAngle

    required property int topGroupTransitionRadius

    required property int shadowMargin

    readonly property int padding: LookAndFeel.spacing.small

    anchors {
        top: true
        left: true
        right: true
    }

    // We make the bar bigger to be able to cast shadows
    implicitHeight: root.barHeight + root.shadowMargin
    // but later we reserve space for the actual top bar only
    exclusiveZone: barHeight

    // We must, however, make the part below the actual bar non-clickable
    mask: Region {
        item: clickthrough_mask
        intersection: Intersection.Xor
    }

    Rectangle {
        id: clickthrough_mask

        width: root.width
        height: root.height - root.barHeight

        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        color: "transparent"
    }

    color: "transparent"

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
