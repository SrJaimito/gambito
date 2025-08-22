import Quickshell

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.Info
import qs.services.Network


RowLayout {
    id: root

    property alias infoSpacing: root.spacing

    spacing: LookAndFeel.spacing.normal

    Info {
        icon: {
            switch (Network.type) {
                case "ethernet":
                    return "\u{f0200}"
                case "wifi":
                    return "\uf1eb"
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

