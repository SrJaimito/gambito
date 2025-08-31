import Quickshell
import Quickshell.Widgets

import QtQuick
import QtQuick.Controls

import qs.config


Item {
    id: root

    required property Item bar

    anchors {
        top: bar.bottom
        right: bar.right
        topMargin: 100
        rightMargin: 100
    }

    implicitWidth: slider.implicitWidth
    implicitHeight: slider.implicitHeight

    WrapperItem {
        id: slider

        anchors.centerIn: parent

        margin: LookAndFeel.spacing.small

        Slider {
            anchors.centerIn: parent
        }
    }
}

