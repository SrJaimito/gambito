import Quickshell
import Quickshell.Hyprland

import QtQuick
// Qualified so it doesn't shadow the sibling Shape.qml
import QtQuick.Shapes as Shapes
import QtQuick.Effects


PanelWindow {
    id: root

    required property PanelWindow bar
    required property int barHeight
    required property int barBorderWidth
    required property int barAngle
    required property int barTransitionRadius
    required property int shadowMargin

    // Length of the bottom edge of the bar group the menu hangs from
    required property real barGroupWidth

    // Whether the menu should be shown. closeRequested() is emitted when the
    // user clicks anywhere outside the menu and the bar
    required property bool open
    signal closeRequested()

    // Size of the menu's content, without its slanted side and shadow
    required property real contentWidth
    required property real contentHeight

    // Stick to the right edge of the screen instead of the left one. The
    // slanted side is always the one away from the screen edge
    property bool alignRight: false

    // Make the side away from the screen edge vertical instead of slanted
    property bool straightSide: false
    readonly property int sideAngle: root.straightSide ? 90 : root.barAngle

    // A menu wider than its bar group would hang below the gap left by the
    // group's slanted end, so it fills that gap instead: it starts under the
    // bar's top border, with a notch shaped like the group cut out of it
    readonly property bool fromBorder: root.barGroupWidth > 0
        && root.contentWidth + root.sideWidth(root.contentHeight) > root.barGroupWidth
    // How much taller the menu gets to reach the border
    readonly property real drop: root.fromBorder ? root.barHeight - root.barBorderWidth : 0

    // Same formula as Shape.slantWidth, but for any height, so fromBorder
    // doesn't depend on the height it changes
    function sideWidth(height) {
        const angle = root.sideAngle * Math.PI / 180;
        const cornerRelX = root.barTransitionRadius * Math.sin(angle);
        const cornerRelY = root.barTransitionRadius * (1 - Math.cos(angle));
        return 2 * cornerRelX + (height - 2 * cornerRelY) / Math.tan(angle);
    }

    default property alias contentData: content.data

    anchors {
        top: true
        left: !root.alignRight
        right: root.alignRight
    }

    // Sit right below the bar (or its border) instead of being pushed by its
    // exclusive zone
    exclusionMode: ExclusionMode.Ignore
    margins.top: root.barHeight - root.drop

    // We make the window bigger than the menu to have room for its shadow
    // on the bottom and the slanted side
    implicitWidth: menu.width + root.shadowMargin
    implicitHeight: menu.height + root.shadowMargin

    // but only the menu itself takes clicks. Regions can only be rectangles,
    // so follow the slanted side with three strips instead of taking clicks
    // on the empty area next to it
    mask: Region {
        Region {
            x: menu.x + (root.alignRight ? menu.stripInset(0) : 0)
            y: menu.y
            width: menu.width - menu.stripInset(0)
            height: menu.height / 3
        }

        Region {
            x: menu.x + (root.alignRight ? menu.stripInset(1) : 0)
            y: menu.y + menu.height / 3
            width: menu.width - menu.stripInset(1)
            height: menu.height / 3
        }

        Region {
            x: menu.x + (root.alignRight ? menu.stripInset(2) : 0)
            y: menu.y + 2 * menu.height / 3
            width: menu.width - menu.stripInset(2)
            height: menu.height / 3
        }

        // Leave the bar group under the notch clickable, so the module that
        // opened the menu can still toggle it
        Region {
            x: root.alignRight ? root.width - width : 0
            y: 0
            width: root.fromBorder ? notch.hitWidth : 0
            height: root.drop

            intersection: Intersection.Subtract
        }
    }

    // Only mapped while open or sliding out, see onYChanged below
    visible: false
    onOpenChanged: if (root.open) root.visible = true

    color: "transparent"

    // Close when clicking anywhere outside the menu, except on the bar so the
    // module that opened the menu can still toggle it
    HyprlandFocusGrab {
        active: root.open && root.visible
        // The bar can briefly be missing while the primary screen changes
        windows: root.bar ? [root, root.bar] : [root]

        onCleared: root.closeRequested()
    }

    // Cuts the notch out of everything the menu draws, shadow included. The
    // notch stays put while the menu slides, so the menu comes out from under
    // the border without ever covering the bar group
    Item {
        anchors.fill: parent

        layer.enabled: root.fromBorder
        layer.effect: MultiEffect {
            maskEnabled: true
            maskInverted: true
            maskSource: notch
        }

        // The menu body: the slanted side plus the content
        Item {
            id: menu

            // Hidden above the window, including the shadow margin so the shadow
            // is tucked away too instead of peeking out from under the bar
            readonly property real hiddenY: -(height + root.shadowMargin)

            // How far the slanted side reaches into the i-th of three mask strips
            function stripInset(i) {
                return shape.slantWidth * (2 * i + 1) / 6;
            }

            width: shape.slantWidth + root.contentWidth
            height: root.contentHeight + root.drop

            x: root.alignRight ? root.shadowMargin : 0

            // Slide down from under the bar's bottom edge
            y: root.open ? 0 : hiddenY

            // Unmap the window once fully slid out. Animations in a Behavior
            // don't emit stopped/finished, so watch the position instead
            onYChanged: {
                if (!root.open && y === hiddenY) {
                    root.visible = false;
                }
            }

            Behavior on y {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutQuad
                }
            }

            Shape {
                id: shape

                container: menu
                shadowMargin: root.shadowMargin
                mirrored: !root.alignRight

                angle: root.sideAngle
                transitionRadius: root.barTransitionRadius
            }

            // Below the notch, which only the filler part of the menu reaches
            Item {
                id: content

                x: root.alignRight ? shape.slantWidth : 0
                y: root.drop

                width: root.contentWidth
                height: root.contentHeight
            }
        }
    }

    // The bar group's end, from its bottom edge to the border, in window
    // coordinates. Only used as a mask texture, never shown
    Item {
        id: notch

        // Clicks on the slanted end go to whichever side of its middle they hit
        readonly property real hitWidth: root.barGroupWidth + notchShape.cornerRelX + notchShape.slantRelX / 2

        anchors.fill: parent

        visible: false
        layer.enabled: true

        Shapes.Shape {
            id: notchShape

            readonly property double angleRad: root.barAngle * Math.PI / 180
            readonly property double cornerRelX: root.barTransitionRadius * Math.sin(angleRad)
            readonly property double cornerRelY: root.barTransitionRadius * (1 - Math.cos(angleRad))
            readonly property double slantRelY: root.drop - 2 * cornerRelY
            readonly property double slantRelX: slantRelY / Math.tan(angleRad)

            // Drawn against the right edge, mirrored like the menu's Shape
            // for menus on the left
            anchors.fill: parent
            transform: Scale {
                xScale: root.alignRight ? 1 : -1
                origin.x: notchShape.width / 2
            }

            // Shrunk by a pixel so the menu overlaps the group's edge: both
            // are the same color, and it hides the bar's shadow seam there
            Shapes.ShapePath {
                fillColor: "black"
                strokeWidth: -1

                startX: notchShape.width + 1
                startY: -1

                PathLine {
                    relativeX: 0
                    y: root.drop - 1
                }

                PathLine {
                    x: notchShape.width - root.barGroupWidth + 1
                    relativeY: 0
                }

                PathArc {
                    relativeX: -notchShape.cornerRelX
                    relativeY: -notchShape.cornerRelY
                    radiusX: root.barTransitionRadius
                    radiusY: root.barTransitionRadius
                }

                PathLine {
                    relativeX: -notchShape.slantRelX
                    relativeY: -notchShape.slantRelY
                }

                PathArc {
                    relativeX: -notchShape.cornerRelX
                    relativeY: -notchShape.cornerRelY
                    radiusX: root.barTransitionRadius
                    radiusY: root.barTransitionRadius
                    direction: PathArc.Counterclockwise
                }

                PathLine {
                    x: notchShape.width + 1
                    y: -1
                }
            }
        }
    }
}
