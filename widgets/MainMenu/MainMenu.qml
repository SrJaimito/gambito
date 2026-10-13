import Quickshell.Widgets

import QtQuick

import qs.config
import qs.components.SlidingMenu


SlidingMenu {
    id: root

    open: UserControl.mainMenuIsVisible
    onCloseRequested: UserControl.mainMenuIsVisible = false

    contentWidth: buttons.implicitWidth + 10
    contentHeight: buttons.implicitHeight

    Shape {
        container: root.contentItem
        shadowMargin: root.shadowMargin
    }

    WrapperItem {
        id: buttons

        anchors.verticalCenter: parent.verticalCenter

        leftMargin: LookAndFeel.spacing.small
        rightMargin: LookAndFeel.spacing.small
        topMargin: LookAndFeel.spacing.tiny
        bottomMargin: LookAndFeel.spacing.tiny

        Buttons {
            spacing: LookAndFeel.spacing.small
        }
    }
}
