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
            relativeX: -root.bar.height / 2
            relativeY: -root.bar.height / 2
            radiusX: root.bar.height / 2
            radiusY: root.bar.height / 2
        }

        PathArc {
            relativeX: -root.bar.height / 4
            relativeY: -root.bar.height / 4
            radiusX: root.bar.height / 4
            radiusY: root.bar.height / 4
            direction: PathArc.Counterclockwise
        }
        
        PathLine {
            x: root.bar.width / 2 + root.centerGroupWidth / 2 + root.bar.height * 0.75
            relativeY: 0
        }

        PathArc {
            relativeX: -root.bar.height / 4
            relativeY: root.bar.height / 4
            radiusX: root.bar.height / 4
            radiusY: root.bar.height / 4
            direction: PathArc.Counterclockwise
        }

        PathArc {
            relativeX: -root.bar.height / 2
            relativeY: root.bar.height / 2
            radiusX: root.bar.height / 2
            radiusY: root.bar.height / 2
        }
        
        PathLine {
            relativeX: -root.centerGroupWidth
            relativeY: 0
        }

        PathArc {
            relativeX: -root.bar.height / 2
            relativeY: -root.bar.height / 2
            radiusX: root.bar.height / 2
            radiusY: root.bar.height / 2
        }

        PathArc {
            relativeX: -root.bar.height / 4
            relativeY: -root.bar.height / 4
            radiusX: root.bar.height / 4
            radiusY: root.bar.height / 4
            direction: PathArc.Counterclockwise
        }
        
        PathLine {
            x: root.leftGroupWidth + root.bar.height * 0.75
            relativeY: 0
        }

        PathArc {
            relativeX: -root.bar.height / 4
            relativeY: root.bar.height / 4
            radiusX: root.bar.height / 4
            radiusY: root.bar.height / 4
            direction: PathArc.Counterclockwise
        }

        PathArc {
            relativeX: -root.bar.height / 2
            relativeY: root.bar.height / 2
            radiusX: root.bar.height / 2
            radiusY: root.bar.height / 2
        }

        PathLine {
            x: 0
            relativeY: 0
        }
    }

    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: "black"
        shadowBlur: 0.5
    }
}

