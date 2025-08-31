import Quickshell

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.Info
import qs.services.Energy


RowLayout {
    id: root

    property alias infoSpacing: root.spacing

    spacing: LookAndFeel.spacing.normal

    Info {
        function chooseColor() {
            if (Energy.hasBattery && !Energy.isCharging) {
                if (Energy.batteryLevel <= 20) {
                    return LookAndFeel.color.red;
                }
            }

            return LookAndFeel.color.text;
        }

        icon: {
            if (!Energy.hasBattery) {
                return "\u{f1425}";
            }

            if (Energy.isCharging) {
                if (Energy.batteryLevel < 40) {
                    return "\u{f12a4}";
                } else if (Energy.batteryLevel < 70) {
                    return "\u{f12a5}";
                } else {
                    return "\u{f12a6}";
                }
            } else {
                if (Energy.batteryLevel < 40) {
                    return "\u{f12a1}";
                } else if (Energy.batteryLevel < 70) {
                    return "\u{f12a2}";
                } else {
                    return "\u{f12a3}";
                }
            }
        }

        iconColor: chooseColor()

        info: Energy.batteryLevel + "%"
        infoVisible: Energy.hasBattery
        infoColor: chooseColor()
    }
}

