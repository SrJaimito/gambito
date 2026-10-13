import Quickshell
import Quickshell.Widgets

import QtQuick

import qs.components.Slider
import qs.services.Audio
import qs.config


PanelWindow {
    id: root

    required property int barHeight

    readonly property bool open: UserControl.audioMenuIsVisible

    anchors {
        top: true
        right: true
    }

    // Sit right below the bar instead of being pushed by its exclusive zone
    exclusionMode: ExclusionMode.Ignore
    margins.top: barHeight

    implicitWidth: content.width
    implicitHeight: content.height

    // Only mapped while open or sliding out, see the animation below
    visible: false
    onOpenChanged: if (open) visible = true

    color: "transparent"

    Item {
        id: content

        implicitWidth: slider.implicitWidth + 10
        implicitHeight: Math.max(slider.implicitHeight, 30)

        // Slide in from the right edge of the screen
        x: root.open ? 0 : width

        Shape {
            container: content
        }

        WrapperItem {
            id: slider

            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            leftMargin: LookAndFeel.spacing.normal
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

        Behavior on x {
            NumberAnimation {
                duration: 500
                easing.type: Easing.OutQuad
                onStopped: {
                    if (!root.open) {
                        root.visible = false;
                    }
                }
            }
        }
    }
}
