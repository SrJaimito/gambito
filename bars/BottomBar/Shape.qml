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

        startX: 0
        startY: 0

        PathArc {
            relativeX: root.screenBorder
            relativeY: root.screenBorder
            radiusX: root.screenBorder
            radiusY: root.screenBorder
            direction: PathArc.Counterclockwise
        }

        PathLine {
            relativeX: root.length
            relativeY: 0
        }

        PathArc {
            relativeX: root.screenBorder * Math.cos(root.angleRad)
            relativeY: root.screenBorder * (1 - Math.sin(root.angleRad))
            radiusX: root.screenBorder
            radiusY: root.screenBorder
        }

        PathLine {
            relativeX: root.screenBorder * Math.tan(root.angleRad) * Math.sin(root.angleRad)
            y: root.bar.height
        }

        PathLine {
            x: 0
            relativeY: 0
        }
    }

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
        }

        PathLine {
            relativeX: -root.length
            relativeY: 0
        }

        PathArc {
            relativeX: -root.screenBorder * Math.cos(root.angleRad)
            relativeY: root.screenBorder * (1 - Math.sin(root.angleRad))
            radiusX: root.screenBorder
            radiusY: root.screenBorder
            direction: PathArc.Counterclockwise
        }

        PathLine {
            relativeX: -root.screenBorder * Math.tan(root.angleRad) * Math.sin(root.angleRad)
            y: root.bar.height
        }

        PathLine {
            x: root.bar.width
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

