import Quickshell.Widgets

import QtQuick

import qs.config
import qs.components.SlidingMenu


SlidingMenu {
    id: root

    open: UserControl.mainMenuIsVisible
    onCloseRequested: UserControl.mainMenuIsVisible = false

    contentWidth: buttons.implicitWidth
    contentHeight: buttons.implicitHeight

    WrapperItem {
        id: buttons

        anchors.verticalCenter: parent.verticalCenter

        leftMargin: LookAndFeel.spacing.small
        rightMargin: LookAndFeel.spacing.tiny
        topMargin: LookAndFeel.spacing.tiny
        bottomMargin: LookAndFeel.spacing.tiny

        Buttons {
            spacing: LookAndFeel.spacing.small
        }
    }
}
