import Quickshell

import QtQuick
import QtQuick.Layouts

import qs.config


RowLayout {
    id: root

    property alias infoSpacing: root.spacing

    spacing: LookAndFeel.spacing.normal

    Energy {}

    Network {}

    Audio {}
}

