import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.SlidingMenu
import qs.components.Label
import qs.components.MenuRow
import qs.components.Slider
import qs.services.Audio


SlidingMenu {
    id: root

    open: UserControl.audioMenuIsVisible
    onCloseRequested: UserControl.audioMenuIsVisible = false

    alignRight: true
    straightSide: true

    // A minimum width keeps the menu from resizing as outputs come and go
    contentWidth: Math.max(content.implicitWidth, 250)
    contentHeight: content.implicitHeight

    WrapperItem {
        id: content

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        leftMargin: LookAndFeel.spacing.tiny
        rightMargin: LookAndFeel.spacing.small
        topMargin: LookAndFeel.spacing.small
        bottomMargin: LookAndFeel.spacing.small

        ColumnLayout {
            spacing: LookAndFeel.spacing.tiny

            // Stretch the slider over the whole row, as wide as the outputs
            // list. The wrapper's implicit width stays fixed so the slider
            // reading the layout's width doesn't feed back into it
            Item {
                Layout.fillWidth: true
                Layout.leftMargin: LookAndFeel.spacing.small

                implicitWidth: 150
                implicitHeight: slider.implicitHeight

                Slider {
                    id: slider

                    anchors.fill: parent

                    sliderWidth: parent.width - circleWidth

                    value: Audio.getVolume()

                    handler: (volume) => {
                        Audio.setVolume(volume);
                    }
                }
            }

            // Separate the volume slider from the outputs list
            Rectangle {
                Layout.fillWidth: true
                Layout.topMargin: LookAndFeel.spacing.tiny
                Layout.bottomMargin: LookAndFeel.spacing.tiny
                implicitHeight: 2

                radius: LookAndFeel.rounding.full

                color: LookAndFeel.color.surface_2
            }

            Repeater {
                model: Audio.sinks

                delegate: MenuRow {
                    required property var modelData

                    Layout.fillWidth: true

                    name: Audio.sinkName(modelData)
                    active: modelData === Audio.sink
                    busy: false

                    onClicked: Audio.setSink(modelData)
                }
            }

            Label {
                Layout.leftMargin: LookAndFeel.spacing.small

                visible: Audio.sinks.length === 0

                text: "No audio outputs"
                color: LookAndFeel.color.overlay_0
            }
        }
    }
}
