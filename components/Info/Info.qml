import Quickshell

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.Label


RowLayout {
    id: root

    property alias iconSpacing: root.spacing

    property alias icon: icon.text
    property alias iconSize: icon.fontSize
    property alias iconColor: icon.color

    property alias info: info.text
    property alias infoSize: info.fontSize
    property alias infoColor: info.color
    property alias infoVisible: info.visible

    spacing: LookAndFeel.spacing.small

    Label {
        id: icon
    }

    Label {
        id: info
    }
}

