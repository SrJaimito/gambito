import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.Label


WrapperRectangle {
    id: root

    readonly property int numberOfWorkspaces: 10

    property alias workspaceSpacing: workspaces.spacing

    // Monitor whose active workspace is highlighted
    required property HyprlandMonitor monitor
    readonly property int activeWorkspaceId: root.monitor?.activeWorkspace?.id ?? -1

    property color focusColor: UserConfig.barHighlightColor
    // Used instead of focusColor when the monitor doesn't have focus
    property color unfocusedColor: Qt.alpha(root.focusColor, 0.5)

    leftMargin: LookAndFeel.spacing.large
    rightMargin: LookAndFeel.spacing.small
    
    topRightRadius: LookAndFeel.rounding.full
    bottomRightRadius: LookAndFeel.rounding.full

    color: LookAndFeel.color.surface_0

    RowLayout {
        id: workspaces

        spacing: LookAndFeel.spacing.normal
        
        Repeater {
            model: root.numberOfWorkspaces

            delegate: Label {
                readonly property bool isActive: index + 1 === root.activeWorkspaceId

                text: {
                    if (isActive) {
                        return "\uea71";
                    }

                    let hyprWorkspaces = Hyprland.workspaces.values;
                    for (let i = 0; i < hyprWorkspaces.length; i++) {
                        if (hyprWorkspaces[i].id === index + 1) {
                            if (hyprWorkspaces[i].toplevels.values.length > 0) {
                                return "\uf192";
                            } else {
                                break;
                            }
                        }
                    }

                    return "\ueabc";
                }

                fontFamily: LookAndFeel.fontFamily.mono
                fontSize: LookAndFeel.fontSize.large

                color: {
                    if (!isActive) {
                        return LookAndFeel.color.text;
                    }

                    return Hyprland.focusedMonitor === root.monitor ? root.focusColor : root.unfocusedColor;
                }
            }
        }
    }
}

