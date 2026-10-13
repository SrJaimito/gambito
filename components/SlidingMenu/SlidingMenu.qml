import Quickshell
import Quickshell.Hyprland

import QtQuick


PanelWindow {
    id: root

    required property PanelWindow bar
    required property int barHeight
    required property int barAngle
    required property int barTransitionRadius
    required property int shadowMargin

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

    default property alias contentData: content.data

    anchors {
        top: true
        left: !root.alignRight
        right: root.alignRight
    }

    // Sit right below the bar instead of being pushed by its exclusive zone
    exclusionMode: ExclusionMode.Ignore
    margins.top: root.barHeight

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
    }

    // Only mapped while open or sliding out, see onYChanged below
    visible: false
    onOpenChanged: if (root.open) root.visible = true

    color: "transparent"

    // Close when clicking anywhere outside the menu, except on the bar so the
    // module that opened the menu can still toggle it
    HyprlandFocusGrab {
        active: root.open && root.visible
        windows: [root, root.bar]

        onCleared: root.closeRequested()
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
        height: root.contentHeight

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

            angle: root.barAngle
            transitionRadius: root.barTransitionRadius
        }

        Item {
            id: content

            x: root.alignRight ? shape.slantWidth : 0

            width: root.contentWidth
            height: root.contentHeight
        }
    }
}
