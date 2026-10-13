import Quickshell
import Quickshell.Widgets

import QtQuick

import qs.config
import qs.components.SlidingMenu
import qs.components.Slider
import qs.services.Audio


SlidingMenu {
    id: root

    required property int barAngle
    required property int barTransitionRadius

    // Height of each horizontal strip of the click mask, see maskRegions
    readonly property real maskStripHeight: root.contentHeight / 3

    open: UserControl.audioMenuIsVisible
    onCloseRequested: UserControl.audioMenuIsVisible = false

    alignRight: true
    slideDown: true
    slideDuration: 300

    contentWidth: shape.slantWidth + slider.implicitWidth
    contentHeight: Math.max(slider.implicitHeight, 30)

    // Regions can only be rectangles, so follow the slanted left side with
    // three strips instead of taking clicks on the empty area next to it
    maskRegions: [
        Region {
            x: root.contentItem.x + shape.slantWidth / 6
            y: root.contentItem.y
            width: root.contentWidth - shape.slantWidth / 6
            height: root.maskStripHeight
        },
        Region {
            x: root.contentItem.x + shape.slantWidth / 2
            y: root.contentItem.y + root.maskStripHeight
            width: root.contentWidth - shape.slantWidth / 2
            height: root.maskStripHeight
        },
        Region {
            x: root.contentItem.x + shape.slantWidth * 5 / 6
            y: root.contentItem.y + 2 * root.maskStripHeight
            width: root.contentWidth - shape.slantWidth * 5 / 6
            height: root.maskStripHeight
        }
    ]

    Shape {
        id: shape

        container: root.contentItem
        shadowMargin: root.shadowMargin

        angle: root.barAngle
        transitionRadius: root.barTransitionRadius
    }

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
