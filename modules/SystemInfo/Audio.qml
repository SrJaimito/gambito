import Quickshell

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.Info
import qs.services.Audio


RowLayout {
    id: root

    property alias infoSpacing: root.spacing

    spacing: LookAndFeel.spacing.normal

    Info {
        icon: {
            if (Audio.isMuted) {
                return "\ueee8";
            }

            if (Audio.volume < 33) {
                return "\uf026";
            } else if (Audio.volume < 66) {
                return "\uf027";
            } else {
                return "\uf028";
            }
        }

        info: Audio.volume + "%"
    }
}

