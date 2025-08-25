import Quickshell
import Quickshell.Widgets

import qs.config
import qs.components.Label


WrapperMouseArea {
    id: root

    property alias focusColor: circle.color

    margin: 0

    cursorShape: Qt.PointingHandCursor

    WrapperRectangle {
        id: circle

        leftMargin: 6
        rightMargin: 6

        radius: LookAndFeel.rounding.full

        color: UserConfig.barHighlightColor

        Label {
            text: "\u{f08c7}"

            fontSize: LookAndFeel.fontSize.larger

            color: LookAndFeel.color.crust
        }
    }
}

