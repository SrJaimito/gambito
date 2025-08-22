import Quickshell

import QtQuick

import qs.config


Text {
    id: root

    property alias fontFamily: root.font.family
    property alias fontSize: root.font.pixelSize

    fontFamily: LookAndFeel.fontFamily.propo
    fontSize: LookAndFeel.fontSize.normal

    color: LookAndFeel.color.text
}

