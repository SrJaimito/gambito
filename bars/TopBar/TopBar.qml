import Quickshell
import Quickshell.Hyprland

import QtQuick

import qs.config
import qs.modules.Workspaces
import qs.modules.DateTime
import qs.modules.SystemInfo


Item {
    id: root

    // Screen whose workspaces are shown
    required property ShellScreen screen

    required property int barHeight
    required property int topBorderWidth
    
    required property int topAngle

    required property int topGroupTransitionRadius

    readonly property int padding: LookAndFeel.spacing.small

    // Bottom edge lengths of the side groups, for the menus hanging from them
    readonly property real leftGroupWidth: leftGroup.width
    readonly property real rightGroupWidth: rightGroup.width + root.padding

    Shape {
        bar: parent

        barHeight: root.barHeight
        topBorderWidth: root.topBorderWidth

        leftGroupWidth: root.leftGroupWidth
        centerGroupWidth: centerGroup.width
        rightGroupWidth: root.rightGroupWidth

        topAngle: root.topAngle

        topGroupTransitionRadius: root.topGroupTransitionRadius
    }

    Item {
        id: leftGroup

        implicitWidth: distroLogo.width / 2 + workspaces.width
        implicitHeight: root.barHeight

        anchors {
            left: parent.left
            top: parent.top
        }

        Workspaces {
            id: workspaces

            monitor: Hyprland.monitorFor(root.screen)

            anchors {
                verticalCenter: distroLogo.verticalCenter
                left: distroLogo.horizontalCenter
            }
        }

        DistroLogo {
            id: distroLogo

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: root.padding
            }
        }
    }

    DateTime {
        id: centerGroup

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: root.padding
        }
    }

    SystemInfo {
        id: rightGroup

        anchors {
            right: parent.right
            top: parent.top
            rightMargin: root.padding
            topMargin: root.padding
        }
    }
}

