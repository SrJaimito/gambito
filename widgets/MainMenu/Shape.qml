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

        startX: 0
        startY: 0

        PathLine {
            relativeX: root.container.width
            relativeY: 0
        }

        PathArc {
            relativeX: -root.container.height / 3
            relativeY: root.container.height / 3
            radiusX: root.container.height / 3
            radiusY: root.container.height / 3
            direction: PathArc.Counterclockwise
        }

        PathArc {
            relativeX: -root.container.height * 2 / 3
            relativeY: root.container.height * 2 / 3
            radiusX: root.container.height * 2 / 3
            radiusY: root.container.height * 2 / 3
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

