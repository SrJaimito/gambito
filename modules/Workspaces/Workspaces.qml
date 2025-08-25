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

    property string focusColor: UserConfig.barHighlightColor

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
                text: {
                    let hyprWorkspaces = Hyprland.workspaces.values;
                    for (let i = 0; i < hyprWorkspaces.length; i++) {
                        if (hyprWorkspaces[i].id === index + 1) {
                            if (hyprWorkspaces[i].focused) {
                                return "\uea71";
                            } else if (hyprWorkspaces[i].toplevels.values.length > 0) {
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

                color: Hyprland.focusedWorkspace.id === index + 1 ? root.focusColor : LookAndFeel.color.text
            }
        }
    }
}

