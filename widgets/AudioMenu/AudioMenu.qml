import Quickshell.Widgets

import QtQuick

import qs.config
import qs.components.SlidingMenu
import qs.components.Slider
import qs.services.Audio


SlidingMenu {
    id: root

    open: UserControl.audioMenuIsVisible
    onCloseRequested: UserControl.audioMenuIsVisible = false

    alignRight: true

    contentWidth: slider.implicitWidth
    contentHeight: Math.max(slider.implicitHeight, 30)

    WrapperItem {
        id: slider

        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        leftMargin: LookAndFeel.spacing.tiny
        rightMargin: LookAndFeel.spacing.small
        topMargin: LookAndFeel.spacing.tiny
        bottomMargin: LookAndFeel.spacing.tiny

        Slider {
            value: Audio.getVolume()

            handler: (volume) => {
                Audio.setVolume(volume);
            }
        }
    }
}
