import Quickshell
import Quickshell.Hyprland

import QtQuick


PanelWindow {
    id: root

    required property PanelWindow bar
    required property int barHeight
    required property int shadowMargin

    // Whether the menu should be shown. closeRequested() is emitted when the
    // user clicks anywhere outside the menu and the bar
    required property bool open
    signal closeRequested()

    // Size of the menu itself, without the room for its shadow
    required property real contentWidth
    required property real contentHeight

    // Stick to the right edge of the screen instead of the left one
    property bool alignRight: false
    // Slide down from the bar instead of sideways from the screen edge
    property bool slideDown: false
    property int slideDuration: 500

    // The item children are placed into, for shapes to draw around
    readonly property Item contentItem: content
    default property alias contentData: content.data

    // Parts of the window that take clicks, the whole menu by default
    property list<Region> maskRegions: [
        Region {
            item: content
        }
    ]

    anchors {
        top: true
        left: !root.alignRight
        right: root.alignRight
    }

    // Sit right below the bar instead of being pushed by its exclusive zone
    exclusionMode: ExclusionMode.Ignore
    margins.top: root.barHeight

    // We make the window bigger than the menu to have room for its shadow
    // on the bottom and on the side away from the screen edge
    implicitWidth: root.contentWidth + root.shadowMargin
    implicitHeight: root.contentHeight + root.shadowMargin

    // but only the menu itself takes clicks
    mask: Region {
        regions: root.maskRegions
    }

    // Only mapped while open or sliding out, see hideIfClosed() below
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

    Item {
        id: content

        // Hidden positions include the shadow margin so the shadow is tucked
        // away too, instead of peeking out from under the bar
        readonly property real shownX: root.alignRight ? root.shadowMargin : 0
        readonly property real hiddenX: {
            if (root.slideDown) {
                return shownX;
            }

            return root.alignRight ? shownX + width + root.shadowMargin : -(width + root.shadowMargin);
        }
        readonly property real hiddenY: root.slideDown ? -(height + root.shadowMargin) : 0

        width: root.contentWidth
        height: root.contentHeight

        x: root.open ? shownX : hiddenX
        y: root.open ? 0 : hiddenY

        // Unmap the window once fully slid out. Animations in a Behavior
        // don't emit stopped/finished, so watch the position instead
        function hideIfClosed() {
            if (!root.open && x === hiddenX && y === hiddenY) {
                root.visible = false;
            }
        }

        onXChanged: hideIfClosed()
        onYChanged: hideIfClosed()

        Behavior on x {
            NumberAnimation {
                duration: root.slideDuration
                easing.type: Easing.OutQuad
            }
        }

        Behavior on y {
            NumberAnimation {
                duration: root.slideDuration
                easing.type: Easing.OutQuad
            }
        }
    }
}
