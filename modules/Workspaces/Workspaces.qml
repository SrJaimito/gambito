import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

import QtQuick
import QtQuick.Layouts

import qs.config


WrapperRectangle {
    property int workspaceSpacing
    property string focusColor

    leftMargin: 0
    topMargin: -2
    bottomMargin: -2
    rightMargin: 15

    radius: LookAndFeel.rounding.full

    color: LookAndFeel.color.surface_0

    RowLayout {
        spacing: workspaceSpacing

        function setWorkspaceIcon(index): string {
            let workspaces = Hyprland.workspaces.values;
            for (let i = 0; i < workspaces.length; i++) {
                if (workspaces[i].id === index + 1) {
                    if (workspaces[i].focused) {
                        return "\uea71";
                    } else if (workspaces[i].toplevels.values.length > 0) {
                        return "\uf192";
                    } else {
                        break;
                    }
                }
            }

            return "\ueabc";
        }

        WrapperMouseArea {
            margin: 0

            cursorShape: Qt.PointingHandCursor
            onClicked: console.log("Hola")

            WrapperRectangle {
                leftMargin: 5
                rightMargin: 5
                topMargin: -6
                bottomMargin: -6

                radius: LookAndFeel.rounding.full

                color: focusColor

                Text {
                    text: "\u{f08c7}"

                    font.pixelSize: LookAndFeel.fontSize.huge
                    font.family: LookAndFeel.fontFamily.mono

                    color: LookAndFeel.color.crust
                }
            }
        }

        Repeater {
            model: totalWorkspaces

            delegate: Text {
                text: parent.setWorkspaceIcon(index)

                font.pixelSize: LookAndFeel.fontSize.large
                font.family: LookAndFeel.fontFamily.mono

                color: Hyprland.focusedWorkspace.id === index + 1 ?
                focusColor : LookAndFeel.color.text
            }
        }
    }
}
