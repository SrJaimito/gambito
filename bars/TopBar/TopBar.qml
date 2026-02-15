import Quickshell

import QtQuick

import qs.config
import qs.modules.Workspaces
import qs.modules.DateTime
import qs.modules.SystemInfo


PanelWindow {
    id: root

    required property int barHeight
    required property int topBorderWidth
    required property int sideBorderWidth
    required property int sideLength
    
    required property int topAngle
    required property int sideAngle

    required property int topGroupTransitionRadius

    readonly property int padding: LookAndFeel.spacing.small

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: barHeight + sideLength + LookAndFeel.spacing.normal
    exclusiveZone: barHeight

    color: "transparent"

    Shape {
        bar: parent

        barHeight: root.barHeight
        topBorderWidth: root.topBorderWidth
        sideBorderWidth: root.sideBorderWidth
        sideLength: root.sideLength

        leftGroupWidth: leftGroup.width
        centerGroupWidth: centerGroup.width
        rightGroupWidth: rightGroup.width + root.padding

        topAngle: root.topAngle
        sideAngle: root.sideAngle

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

