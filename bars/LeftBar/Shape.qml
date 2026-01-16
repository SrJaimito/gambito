import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

import qs.config


Shape {
    id: root

    required property Item bar
    required property int screenBorder
    required property int length
    required property double angle

    readonly property double angleRad: angle * Math.PI / 180

    anchors.fill: bar

    ShapePath {
        fillColor: LookAndFeel.color.crust
        strokeWidth: -1

        startX: root.bar.width
        startY: 0

        PathArc {
            relativeX: -root.screenBorder
            relativeY: root.screenBorder
            radiusX: root.screenBorder
            radiusY: root.screenBorder
            direction: PathArc.Counterclockwise
        }

        PathLine {
            relativeX: 0
            relativeY: root.length
        }

        PathArc {
            relativeX: -root.screenBorder * (1 - Math.sin(root.angleRad))
            relativeY: root.screenBorder * Math.cos(root.angleRad)
            radiusX: root.screenBorder
            radiusY: root.screenBorder
        }

        PathLine {
            x: 0
            relativeY: root.screenBorder * Math.tan(root.angleRad) * Math.sin(root.angleRad)
        }

        PathLine {
            relativeX: 0
            y: 0
        }
    }

    ShapePath {
        fillColor: LookAndFeel.color.crust
        strokeWidth: -1

        startX: root.screenBorder
        startY: root.bar.height

        PathLine {
            relativeX: 0
            relativeY: -(root.screenBorder + root.length)
        }

        PathArc {
            relativeX: -root.screenBorder * (1 - Math.sin(root.angleRad))
            relativeY: -root.screenBorder * Math.cos(root.angleRad)
            radiusX: root.screenBorder
            radiusY: root.screenBorder
            direction: PathArc.Counterclockwise
        }

        PathLine {
            x: 0
            relativeY: -root.screenBorder * Math.tan(root.angleRad) * Math.sin(root.angleRad)
        }

        PathLine {
            x: 0
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

