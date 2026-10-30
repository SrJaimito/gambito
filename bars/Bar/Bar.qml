import Quickshell

import QtQuick

import qs.bars.TopBar
import qs.bars.SecondaryBar


// One per screen. Whether it shows the full bar or only the workspaces
// follows the primary screen, but the window itself is never recreated:
// creating windows while that choice settles at startup made a binding loop
// drop the update and leave bars on the wrong screen
PanelWindow {
    id: root

    // Show the full bar instead of only this screen's workspaces
    required property bool primary

    required property int barHeight
    required property int topBorderWidth

    required property int topAngle

    required property int topGroupTransitionRadius

    required property int shadowMargin

    // Bottom edge lengths of the full bar's side groups, for the menus
    // hanging from them
    readonly property real leftGroupWidth: topBar.leftGroupWidth
    readonly property real rightGroupWidth: topBar.rightGroupWidth
    readonly property real notificationGroupWidth: topBar.notificationGroupWidth

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

    TopBar {
        id: topBar

        anchors.fill: parent
        visible: root.primary

        screen: root.screen

        barHeight: root.barHeight
        topBorderWidth: root.topBorderWidth

        topAngle: root.topAngle

        topGroupTransitionRadius: root.topGroupTransitionRadius
    }

    SecondaryBar {
        anchors.fill: parent
        visible: !root.primary

        screen: root.screen

        barHeight: root.barHeight
        topBorderWidth: root.topBorderWidth

        topAngle: root.topAngle

        topGroupTransitionRadius: root.topGroupTransitionRadius
    }
}
