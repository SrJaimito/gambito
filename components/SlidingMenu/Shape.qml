import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

import qs.config


Shape {
    id: root

    required property Item container

    // Extra room on the bottom and the slanted side for the shadow to be
    // drawn into
    required property int shadowMargin

    // The path is drawn with the slant on the left side. Mirrored, the slant
    // ends up on the right side instead
    required property bool mirrored

    // Same slant and corner radius as the top bar's group transitions
    required property int angle
    readonly property double angleRad: root.angle * Math.PI / 180

    required property int transitionRadius

    readonly property double cornerRelX: root.transitionRadius * Math.sin(root.angleRad)
    readonly property double cornerRelY: root.transitionRadius * (1 - Math.cos(root.angleRad))

    readonly property double slantRelY: root.container.height - 2 * root.cornerRelY
    readonly property double slantRelX: root.slantRelY / Math.tan(root.angleRad)

    // Horizontal space taken by the left side, from top to bottom
    readonly property double slantWidth: 2 * root.cornerRelX + root.slantRelX

    anchors {
        fill: root.container
        leftMargin: root.mirrored ? 0 : -root.shadowMargin
        rightMargin: root.mirrored ? -root.shadowMargin : 0
        bottomMargin: -root.shadowMargin
    }

    transform: Scale {
        xScale: root.mirrored ? -1 : 1
        origin.x: root.width / 2
    }

    ShapePath {
        fillColor: LookAndFeel.color.crust
        strokeWidth: -1

        // Start at top left corner, right below the bar
        startX: root.shadowMargin
        startY: 0

        // Bar to left side transition
        PathArc {
            relativeX: root.cornerRelX
            relativeY: root.cornerRelY
            radiusX: root.transitionRadius
            radiusY: root.transitionRadius
        }

        PathLine {
            relativeX: root.slantRelX
            relativeY: root.slantRelY
        }

        PathArc {
            relativeX: root.cornerRelX
            relativeY: root.cornerRelY
            radiusX: root.transitionRadius
            radiusY: root.transitionRadius
            direction: PathArc.Counterclockwise
        }

        // Move to bottom right corner
        PathLine {
            x: root.shadowMargin + root.container.width
            relativeY: 0
        }

        // Move to top right corner
        PathLine {
            relativeX: 0
            y: 0
        }
    }

    layer.enabled: true
    layer.samples: 6
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: "black"
    }
}
