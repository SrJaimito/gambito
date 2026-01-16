import Quickshell

import QtQuick

import qs.config
import qs.modules.Workspaces
import qs.modules.DateTime
import qs.modules.SystemInfo

PanelWindow {
    id: root

    required property double barAngle

    readonly property int padding: LookAndFeel.spacing.small

    anchors {
        top: true
        left: true
        right: true
    }

    color: "transparent"

    Shape {
        bar: parent
        leftGroupWidth: leftGroup.width
        centerGroupWidth: centerGroup.width
        rightGroupWidth: rightGroup.width + root.padding
        angle: root.barAngle
    }

    Item {
        id: leftGroup

        implicitWidth: distroLogo.width / 2 + workspaces.width

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }

        Workspaces {
            id: workspaces

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

        anchors.centerIn: parent
    }

    SystemInfo {
        id: rightGroup

        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: root.padding
        }
    }
}

