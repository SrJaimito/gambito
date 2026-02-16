import Quickshell

import QtQuick

import qs.bars.TopBar
import qs.bars.BottomBar


Scope {
    id: root

    readonly property int topBarHeight: 40
    readonly property int topBarBorderWidth: 10
    readonly property int topAndBottomBarSideBorderWidth: 6
    readonly property int topAndBottomBarSideLength: 40
    readonly property int topBarTransitionAngle: 60
    readonly property int topAndBottomBarSideAngle: 40
    readonly property int topBarGroupTransitionRadius: 15

    TopBar {
        id: topBar

        barHeight: root.topBarHeight
        topBorderWidth: root.topBarBorderWidth
        sideBorderWidth: root.topAndBottomBarSideBorderWidth
        sideLength: root.topAndBottomBarSideLength
        
        topAngle: root.topBarTransitionAngle
        sideAngle: root.topAndBottomBarSideAngle

        topGroupTransitionRadius: root.topBarGroupTransitionRadius
    }

    BottomBar {
        id: bottomBar

        sideBorderWidth: root.topAndBottomBarSideBorderWidth
        sideLength: root.topAndBottomBarSideLength
        sideAngle: root.topAndBottomBarSideAngle
    }

    // Ghost side panels to create padding
    PanelWindow {
        anchors {
            left: true
        }

        implicitWidth: root.topAndBottomBarSideBorderWidth
        implicitHeight: 50
        exclusiveZone: root.topAndBottomBarSideBorderWidth

        color: "transparent"
    }

    PanelWindow {
        anchors {
            right: true
        }

        implicitWidth: root.topAndBottomBarSideBorderWidth
        implicitHeight: 50
        exclusiveZone: root.topAndBottomBarSideBorderWidth

        color: "transparent"
    }
}

