import Quickshell

import QtQuick

import qs.config
import qs.bars.TopBar
import qs.widgets.MainMenu
import qs.widgets.AudioMenu


Scope {
    id: root

    readonly property int topBarHeight: 40
    readonly property int topBarBorderWidth: 10
    readonly property int topBarTransitionAngle: 60
    readonly property int topBarGroupTransitionRadius: 15

    // Room around the bar and menus for their shadows to be drawn into
    readonly property int shadowMargin: LookAndFeel.spacing.huge

    // Windows without an explicit screen open on whichever monitor has focus
    // when they are mapped, so pin the bar and its menus to the same one
    readonly property ShellScreen screen: Quickshell.screens[0]

    TopBar {
        id: topBar

        screen: root.screen

        barHeight: root.topBarHeight
        topBorderWidth: root.topBarBorderWidth
        
        topAngle: root.topBarTransitionAngle

        topGroupTransitionRadius: root.topBarGroupTransitionRadius

        shadowMargin: root.shadowMargin
    }

    MainMenu {
        screen: root.screen

        bar: topBar
        barHeight: root.topBarHeight
        shadowMargin: root.shadowMargin
    }

    AudioMenu {
        screen: root.screen

        bar: topBar
        barHeight: root.topBarHeight
        barAngle: root.topBarTransitionAngle
        barTransitionRadius: root.topBarGroupTransitionRadius
        shadowMargin: root.shadowMargin
    }
}
