import Quickshell

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.Info
import qs.services.Clock


RowLayout {
    id: root

    property alias infoSpacing: root.spacing

    spacing: LookAndFeel.spacing.normal

    // Date
    Info {
        icon: "\uf133"
        info: Clock.dateText
    }

    // Time
    Info {
        icon: "\uf017"
        info: Clock.timeText
    }
}

