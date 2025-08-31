import Quickshell
import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts

import qs.components.Label
import qs.components.CircleButton
import qs.config


Item {
    id: root

    required property Item bar

    implicitWidth: buttons.implicitWidth + 10
    implicitHeight: buttons.implicitHeight

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

        leftMargin: LookAndFeel.spacing.small
        rightMargin: LookAndFeel.spacing.small
        topMargin: LookAndFeel.spacing.tiny
        bottomMargin: LookAndFeel.spacing.tiny

        Buttons {
            spacing: LookAndFeel.spacing.small
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

