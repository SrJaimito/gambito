import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

import qs.config


Shape {
    id: root

    required property Item bar

    required property int barHeight
    required property int topBorderWidth

    required property int groupWidth

    required property int topAngle
    readonly property double topAngleRad: topAngle * Math.PI / 180

    required property int topGroupTransitionRadius

    readonly property double groupCornerRadiusRelX: topGroupTransitionRadius * Math.sin(topAngleRad)
    readonly property double groupCornerRadiusRelY: topGroupTransitionRadius * (1 - Math.cos(topAngleRad))

    readonly property double groupTransitionRelY: barHeight - topBorderWidth - 2 * groupCornerRadiusRelY
    readonly property double groupTransitionRelX: groupTransitionRelY / Math.tan(topAngleRad)

    anchors.fill: bar

    ShapePath {
        fillColor: LookAndFeel.color.crust
        strokeWidth: -1

        // Start at top left corner
        startX: 0
        startY: 0

        // Move to top right corner
        PathLine {
            relativeX: root.bar.width
            relativeY: 0
        }

        // Move down to the bottom of the border
        PathLine {
            relativeX: 0
            relativeY: root.topBorderWidth
        }

        // Move to group
        PathLine {
            x: root.groupWidth + 2 * root.groupCornerRadiusRelX + root.groupTransitionRelX
            relativeY: 0
        }

        // Border to group transition
        PathArc {
            relativeX: -root.groupCornerRadiusRelX
            relativeY: root.groupCornerRadiusRelY
            radiusX: root.topGroupTransitionRadius
            radiusY: root.topGroupTransitionRadius
            direction: PathArc.Counterclockwise
        }

        PathLine {
            relativeX: -root.groupTransitionRelX
            relativeY: root.groupTransitionRelY
        }

        PathArc {
            relativeX: -root.groupCornerRadiusRelX
            relativeY: root.groupCornerRadiusRelY
            radiusX: root.topGroupTransitionRadius
            radiusY: root.topGroupTransitionRadius
        }

        // Cover group until bottom left corner
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
