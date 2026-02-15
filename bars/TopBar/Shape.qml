import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

import qs.config


Shape {
    id: root

    required property Item bar

    required property int barHeight
    required property int topBorderWidth
    required property int sideBorderWidth
    required property int sideLength
    
    required property int leftGroupWidth
    required property int centerGroupWidth
    required property int rightGroupWidth

    required property int topAngle
    readonly property double topAngleRad: topAngle * Math.PI / 180

    required property int sideAngle
    readonly property double sideAngleRad: sideAngle * Math.PI / 180

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

        // Move to bottom right corner
        PathLine {
            relativeX: 0
            relativeY: root.barHeight + root.sideLength
        }

        // Shape rigth side
        PathLine {
            relativeX: -root.sideBorderWidth * Math.sin(root.sideAngleRad)
            relativeY: -root.sideBorderWidth * Math.tan(root.sideAngleRad) * Math.sin(root.sideAngleRad)
        }

        PathArc {
            relativeX: -root.sideBorderWidth * (1 - Math.sin(root.sideAngleRad))
            relativeY: -root.sideBorderWidth * Math.cos(root.sideAngleRad)
            radiusX: root.sideBorderWidth
            radiusY: root.sideBorderWidth
        }

        PathLine {
            relativeX: 0
            y: root.barHeight + root.sideBorderWidth
        }

        PathArc {
            relativeX: -root.sideBorderWidth
            relativeY: -root.sideBorderWidth
            radiusX: root.sideBorderWidth
            radiusY: root.sideBorderWidth
            direction: PathArc.Counterclockwise
        }

        // Cover right group until corner
        PathLine {
            relativeX: -root.rightGroupWidth + 2 * root.sideBorderWidth
            relativeY: 0
        }

        // Right group to border transition
        PathArc {
            relativeX: -root.groupCornerRadiusRelX
            relativeY: -root.groupCornerRadiusRelY
            radiusX: root.topGroupTransitionRadius
            radiusY: root.topGroupTransitionRadius
        }

        PathLine {
            relativeX: -groupTransitionRelX
            relativeY: -groupTransitionRelY
        }

        PathArc {
            relativeX: -root.groupCornerRadiusRelX
            relativeY: -root.groupCornerRadiusRelY
            radiusX: root.topGroupTransitionRadius
            radiusY: root.topGroupTransitionRadius
            direction: PathArc.Counterclockwise
        }
        
        // Move to center group
        PathLine {
            x: (root.bar.width + root.centerGroupWidth) / 2 + 2 * root.groupCornerRadiusRelX + root.groupTransitionRelX
            relativeY: 0
        }

        // Border to center group transition
        PathArc {
            relativeX: -root.groupCornerRadiusRelX
            relativeY: root.groupCornerRadiusRelY
            radiusX: root.topGroupTransitionRadius
            radiusY: root.topGroupTransitionRadius
            direction: PathArc.Counterclockwise
        }

        PathLine {
            relativeX: -groupTransitionRelX
            relativeY: groupTransitionRelY
        }

        PathArc {
            relativeX: -root.groupCornerRadiusRelX
            relativeY: root.groupCornerRadiusRelY
            radiusX: root.topGroupTransitionRadius
            radiusY: root.topGroupTransitionRadius
        }
        
        // Cover center group
        PathLine {
            relativeX: -root.centerGroupWidth
            relativeY: 0
        }

        // Center group to border transition
        PathArc {
            relativeX: -root.groupCornerRadiusRelX
            relativeY: -root.groupCornerRadiusRelY
            radiusX: root.topGroupTransitionRadius
            radiusY: root.topGroupTransitionRadius
        }

        PathLine {
            relativeX: -groupTransitionRelX
            relativeY: -groupTransitionRelY
        }

        PathArc {
            relativeX: -root.groupCornerRadiusRelX
            relativeY: -root.groupCornerRadiusRelY
            radiusX: root.topGroupTransitionRadius
            radiusY: root.topGroupTransitionRadius
            direction: PathArc.Counterclockwise
        }
        
        // Move to left group
        PathLine {
            x: root.leftGroupWidth + 2 * root.groupCornerRadiusRelX + root.groupTransitionRelX
            relativeY: 0
        }

        // Border to left group transition
        PathArc {
            relativeX: -root.groupCornerRadiusRelX
            relativeY: root.groupCornerRadiusRelY
            radiusX: root.topGroupTransitionRadius
            radiusY: root.topGroupTransitionRadius
            direction: PathArc.Counterclockwise
        }

        PathLine {
            relativeX: -groupTransitionRelX
            relativeY: groupTransitionRelY
        }

        PathArc {
            relativeX: -root.groupCornerRadiusRelX
            relativeY: root.groupCornerRadiusRelY
            radiusX: root.topGroupTransitionRadius
            radiusY: root.topGroupTransitionRadius
        }

        // Cover left group until side
        PathLine {
            x: 2 * root.sideBorderWidth
            relativeY: 0
        }

        // Shape left side
        PathArc {
            relativeX: -root.sideBorderWidth
            relativeY: root.sideBorderWidth
            radiusX: root.sideBorderWidth
            radiusY: root.sideBorderWidth
            direction: PathArc.Counterclockwise
        }

        PathLine {
            relativeX: 0
            relativeY: root.sideLength - root.sideBorderWidth * (Math.tan(root.sideAngleRad) * Math.sin(root.sideAngleRad) + Math.cos(root.sideAngleRad) + 1)
        }

        PathArc {
            relativeX: -root.sideBorderWidth * (1 - Math.sin(root.sideAngleRad))
            relativeY: root.sideBorderWidth * Math.cos(root.sideAngleRad)
            radiusX: root.sideBorderWidth
            radiusY: root.sideBorderWidth
        }

        PathLine {
            relativeX: -root.sideBorderWidth * Math.sin(root.sideAngleRad)
            relativeY: root.sideBorderWidth * Math.tan(root.sideAngleRad) * Math.sin(root.sideAngleRad)
        }
    }

    layer.enabled: true
    layer.samples: 6
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: "black"
    }
}

