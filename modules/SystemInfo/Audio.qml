import Quickshell
import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.Info
import qs.services.Audio


RowLayout {
    id: root

    property alias infoSpacing: root.spacing

    spacing: LookAndFeel.spacing.normal

    WrapperMouseArea {
        margin: 0

        enabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            UserControl.audioMenuIsVisible = !UserControl.audioMenuIsVisible;
        }

        Info {
            icon: {
                if (Audio.isMuted) {
                    return "\ueee8";
                }

                if (Audio.getVolume() < 33) {
                    return "\uf026";
                } else if (Audio.getVolume() < 66) {
                    return "\uf027";
                } else {
                    return "\uf028";
                }
            }

            info: Audio.getVolume() + "%"
        }
    }
}

