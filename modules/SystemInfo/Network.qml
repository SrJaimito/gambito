import Quickshell
import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.Info
import qs.services.Network


RowLayout {
    id: root

    property alias infoSpacing: root.spacing

    spacing: LookAndFeel.spacing.normal

    WrapperMouseArea {
        margin: 0

        enabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            UserControl.networkMenuIsVisible = !UserControl.networkMenuIsVisible;
            // Both menus slide out at the right edge, so don't stack them
            UserControl.audioMenuIsVisible = false;
        }

        Info {
            icon: {
                switch (Network.type) {
                    case "ethernet":
                        return "\u{f0200}"
                    case "wifi":
                        return ""
                    default:
                        return "\u{f04b4}"
                }
            }

            info: {
                switch (Network.type) {
                    case "ethernet":
                        return "Eth";
                    case "wifi":
                        return Network.wifiName;
                    default:
                        return "No network";
                }
            }
        }
    }
}
