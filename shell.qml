import Quickshell
import Quickshell.Hyprland

import QtQuick
import QtQuick.Effects

import qs.config
import qs.modules.Workspaces
import qs.modules.DateTime
import qs.modules.SystemInfo


PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 40

    color: "transparent"

    readonly property int totalWorkspaces: 10

    Rectangle {
        id: background

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.verticalCenter
        }

        color: LookAndFeel.color.crust

        layer.enabled: true
        layer.effect: MultiEffect {
            maskSource: mask
            maskEnabled: true
            maskInverted: true

            maskThresholdMin: 0.5
            maskSpreadAtMin: 1
        }
    }

    Item {
        id: mask

        anchors.fill: background

        layer.enabled: true
        visible: false

        Rectangle {
            x: leftGroupCapsule.x + leftGroupCapsule.width
            y: parent.height / 1.5
            width: centerGroupCapsule.x - (leftGroupCapsule.x + leftGroupCapsule.width)
            height: parent.height

            radius: LookAndFeel.rounding.full
        }

        Rectangle {
            x: centerGroupCapsule.x + centerGroupCapsule.width
            y: parent.height / 1.5
            width: rightGroupCapsule.x - (centerGroupCapsule.x + centerGroupCapsule.width)
            height: parent.height

            radius: LookAndFeel.rounding.full
        }
    }

    Rectangle {
        id: leftGroupCapsule

        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
            right: leftGroup.right
            rightMargin: -LookAndFeel.spacing.small
        }

        bottomRightRadius: LookAndFeel.rounding.full

        color: LookAndFeel.color.crust
    }

    Rectangle {
        id: centerGroupCapsule

        anchors {
            top: parent.top
            left: centerGroup.left
            bottom: parent.bottom
            right: centerGroup.right
            leftMargin: -LookAndFeel.spacing.normal
            rightMargin: -LookAndFeel.spacing.normal
        }

        radius: LookAndFeel.rounding.full

        color: LookAndFeel.color.crust
    }

    Rectangle {
        id: rightGroupCapsule

        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
            left: rightGroup.left
            leftMargin: -LookAndFeel.spacing.normal
        }

        bottomLeftRadius: LookAndFeel.rounding.full

        color: LookAndFeel.color.crust
    }

    Workspaces {
        id: leftGroup

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: LookAndFeel.spacing.small
        }

        workspaceSpacing: LookAndFeel.spacing.normal
        focusColor: LookAndFeel.color.sapphire
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
            rightMargin: LookAndFeel.spacing.small
        }
    }
}

