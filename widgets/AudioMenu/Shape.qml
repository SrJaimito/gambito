import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

import qs.config


Shape {
    id: root

    required property Item container

    anchors.fill: container

    ShapePath {
        fillColor: UserConfig.barHighlightColor
        strokeWidth: -1

        startX: root.container.width
        startY: 0

        PathLine {
            relativeX: -root.container.width
            relativeY: 0
        }

        PathArc {
            relativeX: 10
            relativeY: 10
            radiusX: 10
            radiusY: 10
        }

        PathLine {
            relativeX: 0
            relativeY: root.container.height - 30
        }

        PathArc {
            relativeX: 20
            relativeY: 20
            radiusX: 20
            radiusY: 20
            direction: PathArc.Counterclockwise
        }

        PathLine {
            relativeX: root.container.width
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


