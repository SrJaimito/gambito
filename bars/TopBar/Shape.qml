import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

import qs.config


Shape {
    id: root

    required property Item bar
    required property int leftGroupWidth
    required property int centerGroupWidth
    required property int rightGroupWidth
    required property double angle

    readonly property double cornerRadius: 20
    readonly property double borderWidth: 10

    readonly property double angleRadians: angle * Math.PI / 180

    readonly property double groupCornerRadiusRelX: cornerRadius * Math.sin(angleRadians)
    readonly property double groupCornerRadiusRelY: cornerRadius * (1 - Math.cos(angleRadians))

    readonly property double groupTransitionRelY: bar.height - borderWidth - 2 * groupCornerRadiusRelY
    readonly property double groupTransitionRelX: groupTransitionRelY / Math.tan(angleRadians)

    anchors.fill: bar

    ShapePath {
        fillColor: LookAndFeel.color.crust
        strokeWidth: -1

        startX: 0
        startY: 0

        PathLine {
            relativeX: root.bar.width
            relativeY: 0
        }

        PathLine {
            relativeX: 0
            relativeY: root.bar.height
        }

        PathLine {
            relativeX: -root.rightGroupWidth
            relativeY: 0
        }

        PathArc {
            relativeX: -root.groupCornerRadiusRelX
            relativeY: -root.groupCornerRadiusRelY
            radiusX: root.cornerRadius
            radiusY: root.cornerRadius
        }

        PathLine {
            relativeX: -groupTransitionRelX
            relativeY: -groupTransitionRelY
        }

        PathArc {
            relativeX: -root.groupCornerRadiusRelX
            relativeY: -root.groupCornerRadiusRelY
            radiusX: root.cornerRadius
            radiusY: root.cornerRadius
            direction: PathArc.Counterclockwise
        }
        
        PathLine {
            x: (root.bar.width + root.centerGroupWidth) / 2 + 2 * root.groupCornerRadiusRelX + root.groupTransitionRelX
            relativeY: 0
        }

        PathArc {
            relativeX: -root.groupCornerRadiusRelX
            relativeY: root.groupCornerRadiusRelY
            radiusX: root.cornerRadius
            radiusY: root.cornerRadius
            direction: PathArc.Counterclockwise
        }

        PathLine {
            relativeX: -groupTransitionRelX
            relativeY: groupTransitionRelY
        }

        PathArc {
            relativeX: -root.groupCornerRadiusRelX
            relativeY: root.groupCornerRadiusRelY
            radiusX: root.cornerRadius
            radiusY: root.cornerRadius
        }
        
        PathLine {
            relativeX: -root.centerGroupWidth
            relativeY: 0
        }

        PathArc {
            relativeX: -root.groupCornerRadiusRelX
            relativeY: -root.groupCornerRadiusRelY
            radiusX: root.cornerRadius
            radiusY: root.cornerRadius
        }

        PathLine {
            relativeX: -groupTransitionRelX
            relativeY: -groupTransitionRelY
        }

        PathArc {
            relativeX: -root.groupCornerRadiusRelX
            relativeY: -root.groupCornerRadiusRelY
            radiusX: root.cornerRadius
            radiusY: root.cornerRadius
            direction: PathArc.Counterclockwise
        }
        
        PathLine {
            x: root.leftGroupWidth + 2 * root.groupCornerRadiusRelX + root.groupTransitionRelX
            relativeY: 0
        }

        PathArc {
            relativeX: -root.groupCornerRadiusRelX
            relativeY: root.groupCornerRadiusRelY
            radiusX: root.cornerRadius
            radiusY: root.cornerRadius
            direction: PathArc.Counterclockwise
        }

        PathLine {
            relativeX: -groupTransitionRelX
            relativeY: groupTransitionRelY
        }

        PathArc {
            relativeX: -root.groupCornerRadiusRelX
            relativeY: root.groupCornerRadiusRelY
            radiusX: root.cornerRadius
            radiusY: root.cornerRadius
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

