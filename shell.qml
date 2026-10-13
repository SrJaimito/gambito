import Quickshell

import QtQuick

import qs.bars.TopBar
import qs.widgets.MainMenu
import qs.widgets.AudioMenu


Scope {
    id: root

    readonly property int topBarHeight: 40
    readonly property int topBarBorderWidth: 10
    readonly property int topBarTransitionAngle: 60
    readonly property int topBarGroupTransitionRadius: 15

    TopBar {
        id: topBar

        barHeight: root.topBarHeight
        topBorderWidth: root.topBarBorderWidth
        
        topAngle: root.topBarTransitionAngle

        topGroupTransitionRadius: root.topBarGroupTransitionRadius
    }

    MainMenu {
        barHeight: root.topBarHeight
    }

    AudioMenu {
        barHeight: root.topBarHeight
    }
}
