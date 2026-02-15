import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

import qs.config


Shape {
    id: root

    required property Item bar

    required property int sideBorderWidth
    required property int sideLength
    required property int sideAngle

    readonly property double sideAngleRad: sideAngle * Math.PI / 180

    anchors.fill: bar

    ShapePath {
        fillColor: LookAndFeel.color.crust
        strokeWidth: -1

        startX: 0
        startY: root.bar.height - (root.sideLength + root.sideBorderWidth)

        // Shape left side
        PathLine {
            relativeX: root.sideBorderWidth * Math.sin(root.sideAngleRad)
            relativeY: root.sideBorderWidth * Math.tan(root.sideAngleRad) * Math.sin(root.sideAngleRad)
        }

        PathArc {
            relativeX: root.sideBorderWidth * (1 - Math.sin(root.sideAngleRad))
            relativeY: root.sideBorderWidth * Math.cos(root.sideAngleRad)
            radiusX: root.sideBorderWidth
            radiusY: root.sideBorderWidth
        }

        PathLine {
            relativeX: 0
            y: root.bar.height - root.sideBorderWidth * 2
        }

        PathArc {
            relativeX: root.sideBorderWidth
            relativeY: root.sideBorderWidth
            radiusX: root.sideBorderWidth
            radiusY: root.sideBorderWidth
            direction: PathArc.Counterclockwise
        }

        PathLine {
            relativeX: root.sideLength - root.sideBorderWidth * (1 + Math.cos(root.sideAngleRad) + Math.tan(root.sideAngleRad) * Math.sin(root.sideAngleRad))
            relativeY: 0
        }

        PathArc {
            relativeX: root.sideBorderWidth * Math.cos(root.sideAngleRad)
            relativeY: root.sideBorderWidth * (1 - Math.sin(root.sideAngleRad))
            radiusX: root.sideBorderWidth
            radiusY: root.sideBorderWidth
        }

        PathLine {
            relativeX: root.sideBorderWidth * Math.tan(root.sideAngleRad) * Math.sin(root.sideAngleRad)
            y: root.bar.height
        }

        PathLine {
            x: 0
            y: root.bar.height
        }
    }

    ShapePath {
        fillColor: LookAndFeel.color.crust
        strokeWidth: -1

        startX: root.bar.width
        startY: root.bar.height - (root.sideLength + root.sideBorderWidth)

        // Shape right side
        PathLine {
            relativeX: -root.sideBorderWidth * Math.sin(root.sideAngleRad)
            relativeY: root.sideBorderWidth * Math.tan(root.sideAngleRad) * Math.sin(root.sideAngleRad)
        }

        PathArc {
            relativeX: -root.sideBorderWidth * (1 - Math.sin(root.sideAngleRad))
            relativeY: root.sideBorderWidth * Math.cos(root.sideAngleRad)
            radiusX: root.sideBorderWidth
            radiusY: root.sideBorderWidth
            direction: PathArc.Counterclockwise
        }

        PathLine {
            relativeX: 0
            y: root.bar.height - root.sideBorderWidth * 2
        }

        PathArc {
            relativeX: -root.sideBorderWidth
            relativeY: root.sideBorderWidth
            radiusX: root.sideBorderWidth
            radiusY: root.sideBorderWidth
        }

        PathLine {
            relativeX: -root.sideLength + root.sideBorderWidth * (1 + Math.cos(root.sideAngleRad) + Math.tan(root.sideAngleRad) * Math.sin(root.sideAngleRad))
            relativeY: 0
        }

        PathArc {
            relativeX: -root.sideBorderWidth * Math.cos(root.sideAngleRad)
            relativeY: root.sideBorderWidth * (1 - Math.sin(root.sideAngleRad))
            radiusX: root.sideBorderWidth
            radiusY: root.sideBorderWidth
            direction: PathArc.Counterclockwise
        }

        PathLine {
            relativeX: -root.sideBorderWidth * Math.tan(root.sideAngleRad) * Math.sin(root.sideAngleRad)
            y: root.bar.height
        }

        PathLine {
            x: root.bar.width
            y: root.bar.height
        }
    }

    layer.enabled: true
    layer.samples: 6
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: "black"
    }
}

