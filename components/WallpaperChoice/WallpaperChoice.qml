import QtQuick
import QtQuick.Effects
import Qt.labs.folderlistmodel

import qs.config


// A scrollable row of thumbnails to pick one of the pictures in a folder
ListView {
    id: root

    // Directory whose pictures are offered
    required property string folder
    // Path of the chosen picture, kept in sync with the outside world
    required property string selected
    // Called with the path of the picture the user clicks
    required property var handler

    property int thumbnailHeight: 90
    // Pictures are cropped to the usual screen proportions
    property int thumbnailWidth: Math.round(thumbnailHeight * 16 / 9)

    // Room around the thumbnail for the selection ring
    readonly property int ringWidth: 4

    implicitHeight: thumbnailHeight + 2 * ringWidth

    orientation: ListView.Horizontal
    spacing: LookAndFeel.spacing.tiny
    clip: true
    boundsBehavior: Flickable.StopAtBounds

    model: FolderListModel {
        folder: "file://" + root.folder
        nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp"]
        showDirs: false
    }

    // Show the chosen picture once the folder has been listed
    onCountChanged: {
        const index = [...Array(count).keys()].find(i => model.get(i, "filePath") === root.selected);
        if (index !== undefined) {
            positionViewAtIndex(index, ListView.Contain);
        }
    }

    // A mouse wheel scrolls vertically, turn that into horizontal scrolling
    WheelHandler {
        acceptedDevices: PointerDevice.Mouse
        onWheel: (event) => {
            root.flick(event.angleDelta.y * 10, 0);
        }
    }

    delegate: Rectangle {
        id: ring

        required property string filePath

        readonly property bool isSelected: filePath === root.selected

        implicitWidth: root.thumbnailWidth + 2 * root.ringWidth
        implicitHeight: root.thumbnailHeight + 2 * root.ringWidth

        radius: LookAndFeel.rounding.small + root.ringWidth

        color: "transparent"
        border.width: 2
        border.color: ring.isSelected ? LookAndFeel.color.text
                    : thumbnailArea.containsMouse ? LookAndFeel.color.surface_2
                    : "transparent"

        Image {
            id: thumbnail

            anchors.centerIn: parent

            width: root.thumbnailWidth
            height: root.thumbnailHeight

            source: "file://" + ring.filePath
            // Otherwise every wallpaper is decoded at its full resolution
            sourceSize.width: width
            sourceSize.height: height
            fillMode: Image.PreserveAspectCrop
            asynchronous: true

            // Round the corners
            layer.enabled: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: thumbnailMask
                maskThresholdMin: 0.5
                maskSpreadAtMin: 1.0
            }
        }

        Rectangle {
            id: thumbnailMask

            width: thumbnail.width
            height: thumbnail.height

            radius: LookAndFeel.rounding.small

            visible: false
            layer.enabled: true
        }

        MouseArea {
            id: thumbnailArea

            anchors.fill: parent

            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: root.handler(ring.filePath)
        }
    }
}
