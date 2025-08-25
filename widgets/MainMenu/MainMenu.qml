import Quickshell
import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts

import qs.components.Label
import qs.config


Item {
    id: root

    required property Item bar

    implicitWidth: buttons.implicitWidth + implicitHeight
    implicitHeight: 30

    anchors {
        top: bar.bottom
        left: parent.left
        leftMargin: UserControl.mainMenuIsVisible ? 0 : -implicitWidth
    }
    
    Shape {
        container: parent
    }

    WrapperItem {
        id: buttons

        anchors.verticalCenter: parent.verticalCenter

        leftMargin: LookAndFeel.spacing.normal

        RowLayout {
            spacing: LookAndFeel.spacing.normal
            
            Label {
                text: "\uf456"
                fontSize: LookAndFeel.fontSize.normal
                color: LookAndFeel.color.crust
            }
            
            Label {
                text: "\u{f0fc5}"
                fontSize: LookAndFeel.fontSize.normal
                color: LookAndFeel.color.crust
            }
            
            Label {
                text: "\uf011"
                fontSize: LookAndFeel.fontSize.normal
                color: LookAndFeel.color.crust
            }
        }
    }

    Behavior on anchors.leftMargin {
        NumberAnimation {
            duration: 500
            easing.type: Easing.OutQuad
            onStarted: {
                if (!root.visible) {
                    root.visible = true;
                }
            }
            onStopped: {
                if (root.visible) {
                    root.visible = false;
                }
            }
        }
    }
}

