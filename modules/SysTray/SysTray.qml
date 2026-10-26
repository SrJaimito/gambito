import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.SlidingMenu


// A strip tucked under the bar: its top hides under the bar's top border and
// its right end under the slanted side of the group next to it, so the bar
// (and its shadow) is drawn on top of it. Only the left side, slanted like the
// bar's groups, and the band below the border are visible
Item {
    id: root

    required property int barHeight
    required property int topBorderWidth

    required property int topAngle

    required property int topGroupTransitionRadius

    readonly property int padding: LookAndFeel.spacing.tiny

    // Own slanted side plus the part hidden under the next group's one, which
    // has the same height and angle
    implicitWidth: 2 * shape.slantWidth + 2 * root.padding + icons.implicitWidth
    implicitHeight: root.barHeight

    visible: SystemTray.items.values.length > 0

    Shape {
        id: shape

        container: root
        // The bar's shadow falls on the strip, its own would only be clipped
        shadowMargin: 0
        mirrored: false

        angle: root.topAngle
        transitionRadius: root.topGroupTransitionRadius

        color: UserConfig.barHighlightColor
    }

    RowLayout {
        id: icons

        x: shape.slantWidth + root.padding
        // Centered in the band left visible below the border
        y: root.topBorderWidth + (root.barHeight - root.topBorderWidth - height) / 2

        spacing: LookAndFeel.spacing.small

        Repeater {
            model: SystemTray.items

            delegate: MouseArea {
                id: trayItem

                required property SystemTrayItem modelData

                implicitWidth: icon.implicitWidth
                implicitHeight: icon.implicitHeight

                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                cursorShape: Qt.PointingHandCursor

                // Open the item's own menu right below its icon
                function openMenu() {
                    const window = QsWindow.window;
                    const pos = trayItem.mapToItem(window.contentItem, 0, trayItem.height);
                    trayItem.modelData.display(window, pos.x, pos.y);
                }

                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        if (trayItem.modelData.onlyMenu) {
                            trayItem.openMenu();
                        } else {
                            trayItem.modelData.activate();
                        }
                    } else if (mouse.button === Qt.RightButton) {
                        if (trayItem.modelData.hasMenu) {
                            trayItem.openMenu();
                        }
                    } else {
                        trayItem.modelData.secondaryActivate();
                    }
                }

                onWheel: wheel => trayItem.modelData.scroll(wheel.angleDelta.y, false)

                IconImage {
                    id: icon

                    source: trayItem.modelData.icon
                    implicitSize: LookAndFeel.fontSize.large
                }
            }
        }
    }
}
