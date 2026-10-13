import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

import qs.config


Shape {
    id: root

    required property Item container

    // Extra room on the right and bottom for the shadow to be drawn into
    required property int shadowMargin

    anchors {
        fill: root.container
        rightMargin: -root.shadowMargin
        bottomMargin: -root.shadowMargin
    }

    ShapePath {
        fillColor: UserConfig.barHighlightColor
        strokeWidth: -1

        startX: 0
        startY: 0

        PathLine {
            relativeX: root.container.width
            relativeY: 0
        }

        PathArc {
            relativeX: -LookAndFeel.rounding.small
            relativeY: LookAndFeel.rounding.small
            radiusX: LookAndFeel.rounding.small
            radiusY: LookAndFeel.rounding.small
            direction: PathArc.Counterclockwise
        }

        PathLine {
            relativeX: 0
            relativeY: root.container.height - LookAndFeel.rounding.normal - LookAndFeel.rounding.small
        }

        PathArc {
            relativeX: -LookAndFeel.rounding.normal
            relativeY: LookAndFeel.rounding.normal
            radiusX: LookAndFeel.rounding.normal
            radiusY: LookAndFeel.rounding.normal
        }

        PathLine {
            x: 0
            relativeY: 0
        }
    }

    layer.enabled: true
    layer.samples: 6
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: "black"
    }
}

