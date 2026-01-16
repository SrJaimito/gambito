import Quickshell

import QtQuick

import qs.bars.TopBar
import qs.bars.RightBar
import qs.bars.LeftBar
import qs.bars.BottomBar


Scope {
    id: root

    readonly property int topBarHeight: 40
    readonly property int screenBorder: 6
    readonly property int sideBarLength: 80
    readonly property double topBarAngle: 60
    readonly property double sideBarAngle: 40

    TopBar {
        implicitHeight: root.topBarHeight
        barAngle: root.topBarAngle
    }

    RightBar {
        implicitWidth: 2 * root.screenBorder
        length: root.sideBarLength
        angle: root.sideBarAngle
    }

    LeftBar {
        implicitWidth: 2 * root.screenBorder
        length: root.sideBarLength
        angle: root.sideBarAngle
    }

    BottomBar {
        implicitHeight: 2 * root.screenBorder
        length: root.sideBarLength
        angle: root.sideBarAngle
    }
}

// PanelWindow {
//     id: root
// 
//     readonly property int topBarHeight: 40
//     readonly property int screenBorder: 10
// 
//     anchors {
//         top: true
//         left: true
//         right: true
//     }
// 
//     implicitHeight: screen.height
//     exclusiveZone: topBarHeight
// 
//     color: "transparent"
// 
//     TopBar {
//         id: topBar
// 
//         anchors {
//             left: parent.left
//             right: parent.right
//             top: parent.top
//         }
// 
//         implicitHeight: root.topBarHeight
//     }
// }

