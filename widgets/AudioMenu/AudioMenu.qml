import Quickshell
import Quickshell.Widgets

import QtQuick

import qs.components.Slider
import qs.services.Audio
import qs.config


Item {
    id: root

    required property Item bar

    anchors {
        top: bar.bottom
        right: bar.right
        rightMargin: UserControl.audioMenuIsVisible ? 0 : -implicitWidth
    }

    implicitWidth: slider.implicitWidth + 10
    implicitHeight: Math.max(slider.implicitHeight, 30)

    Shape {
        container: root
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
            Component.onCompleted: {
                initPosition = Audio.getVolume();
            }

            handler: (volume) => {
                Audio.setVolume(volume);
            }
        }
    }

    Behavior on anchors.rightMargin {
        NumberAnimation {
            duration: 500
            easing.type: Easing.OutQuad
            onStarted: {
                if (!root.visible) {
                    root.visible = true;
                }
            }
            onStopped: {
                if (root.visible) {
                    root.visible = false;
                }
            }
        }
    }
}

