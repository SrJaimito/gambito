import Quickshell
import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.Label
import qs.components.SlidingMenu
import qs.services.Notifications


// The unread notifications, one icon per app. Built like SysTray, mirrored to
// sit after the bar's left group: its top hides under the bar's top border and
// its left end under the group's slanted side, so only its right side, slanted
// like the bar's groups, and the band below the border are visible
Item {
    id: root

    required property int barHeight
    required property int topBorderWidth

    required property int topAngle

    required property int topGroupTransitionRadius

    readonly property int padding: LookAndFeel.spacing.tiny
    readonly property int iconSize: LookAndFeel.fontSize.large

    // Width of the part hidden under the left group, so the bar can tell how
    // far the visible part reaches
    readonly property real slantWidth: shape.slantWidth

    // Both slanted sides (the left group's and the strip's own, same angle)
    // lean right going up, so near the icons they're much closer than a full
    // slant width. Measure the padding from where each side actually is: the
    // group's at the icons' top, the strip's at their bottom, the points
    // closest to them
    readonly property real cotAngle: 1 / Math.tan(root.topAngle * Math.PI / 180)
    readonly property real iconsTop: root.topBorderWidth + (root.barHeight - root.topBorderWidth - icons.implicitHeight) / 2
    readonly property real iconsBottom: root.iconsTop + icons.implicitHeight

    implicitWidth: icons.x + icons.implicitWidth + root.padding
        + shape.cornerRelX + (root.iconsBottom - shape.cornerRelY) * root.cotAngle
    implicitHeight: root.barHeight

    // Also shown while Do Not Disturb is on, so it doesn't go unnoticed
    visible: Notifications.unread.length > 0 || UserConfig.doNotDisturb

    Shape {
        id: shape

        container: root
        // The bar's shadow falls on the strip, its own would only be clipped
        shadowMargin: 0
        mirrored: true

        angle: root.topAngle
        transitionRadius: root.topGroupTransitionRadius

        color: UserConfig.barHighlightColor
    }

    MouseArea {
        anchors.fill: icons

        enabled: Notifications.unread.length > 0
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            UserControl.notificationMenuIsVisible = !UserControl.notificationMenuIsVisible;
            // Both menus hang from the left group, so don't stack them
            UserControl.mainMenuIsVisible = false;
        }
    }

    RowLayout {
        id: icons

        x: shape.cornerRelX + (root.barHeight - shape.cornerRelY - root.iconsTop) * root.cotAngle + root.padding
        // Centered in the band left visible below the border
        y: root.iconsTop

        spacing: LookAndFeel.spacing.small

        Label {
            visible: UserConfig.doNotDisturb

            fontSize: root.iconSize
            text: "\u{f009b}"
            color: LookAndFeel.color.crust
        }

        Repeater {
            model: Notifications.apps

            delegate: Item {
                id: app

                required property var modelData

                implicitWidth: root.iconSize
                implicitHeight: root.iconSize

                IconImage {
                    anchors.fill: parent

                    visible: app.modelData.icon !== ""
                    source: app.modelData.icon
                }

                // Bell for apps without an icon
                Label {
                    anchors.centerIn: parent

                    visible: app.modelData.icon === ""

                    fontSize: root.iconSize
                    text: "\u{f009a}"
                    color: LookAndFeel.color.crust
                }

                // How many notifications the app has, when more than one
                Rectangle {
                    readonly property int count: app.modelData.notifications.length

                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                        rightMargin: -root.padding
                        bottomMargin: -root.padding
                    }

                    visible: count > 1

                    width: Math.max(height, countLabel.implicitWidth + 4)
                    height: countLabel.implicitHeight

                    radius: LookAndFeel.rounding.full

                    color: LookAndFeel.color.crust

                    Label {
                        id: countLabel

                        anchors.centerIn: parent

                        fontSize: root.iconSize * 0.55
                        font.bold: true
                        text: parent.count > 9 ? "9+" : parent.count
                        color: UserConfig.barHighlightColor
                    }
                }
            }
        }
    }
}
