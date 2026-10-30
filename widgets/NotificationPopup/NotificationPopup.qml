import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

import qs.config
import qs.components.Label
import qs.services.Notifications


// Shows new notifications one at a time, centered right below the bar and
// above every window. Left click runs the default action, right click just
// marks it read; letting it time out leaves it unread in the bar
PanelWindow {
    id: root

    required property int barHeight
    required property int shadowMargin

    readonly property int bodyWidth: 400
    readonly property int iconSize: 48

    // Notifications waiting for the current one to go away
    property var queue: []
    // The one on screen. Becomes null once it's closed, so what is drawn is a
    // copy taken when it's shown, which stays put while it fades out
    property var current: null
    property string appName: ""
    property string summary: ""
    property string body: ""
    property string icon: ""

    property bool shown: false

    function showNext() {
        while (root.queue.length > 0) {
            const n = root.queue.shift();

            // Skip the ones read or closed while waiting
            if (n?.tracked) {
                root.current = n;
                root.appName = n.appName;
                root.summary = n.summary;
                root.body = n.body;
                root.icon = Notifications.iconFor(n);

                hideTimer.interval = Notifications.timeout(n);
                root.shown = true;
                return;
            }
        }

        root.current = null;
    }

    function hide() {
        root.shown = false;
    }

    // Without anchors on the sides the compositor centers it horizontally
    anchors.top: true
    margins.top: root.barHeight + LookAndFeel.spacing.small - root.shadowMargin

    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    // We make the window bigger than its body to have room for its shadow
    implicitWidth: card.width + 2 * root.shadowMargin
    implicitHeight: card.height + 2 * root.shadowMargin

    // but only the card itself takes clicks
    mask: Region {
        item: card
    }

    // Stay mapped until the fade out is over
    visible: root.shown || card.opacity > 0

    color: "transparent"

    Connections {
        target: Notifications

        function onReceived(n) {
            root.queue.push(n);

            if (!root.visible) {
                root.showNext();
            }
        }
    }

    Connections {
        target: UserConfig

        // Drop what's on screen and waiting, it's all still in the bar
        function onDoNotDisturbChanged() {
            if (UserConfig.doNotDisturb) {
                root.queue = [];
                root.hide();
            }
        }
    }

    // The app took it back
    Connections {
        target: root.current

        function onClosed() {
            root.hide();
        }
    }

    Timer {
        id: hideTimer

        // Restarts from the beginning when the pointer leaves
        running: root.shown && !mouseArea.containsMouse

        onTriggered: {
            Notifications.popupTimedOut(root.current);
            root.hide();
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: card

        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                Notifications.invoke(root.current);
            } else {
                Notifications.dismiss(root.current);
            }

            root.hide();
        }
    }

    Rectangle {
        id: card

        width: root.bodyWidth
        height: row.implicitHeight + 2 * LookAndFeel.spacing.small

        anchors.centerIn: parent
        // Drop a little while fading in
        anchors.verticalCenterOffset: root.shown ? 0 : -LookAndFeel.spacing.small

        radius: LookAndFeel.rounding.small

        color: LookAndFeel.color.base

        opacity: root.shown ? 1 : 0

        // Bring the next one in once this one is gone
        onOpacityChanged: {
            if (!root.shown && opacity === 0) {
                root.showNext();
            }
        }

        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }

        Behavior on anchors.verticalCenterOffset {
            NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "black"
        }

        RowLayout {
            id: row

            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
                leftMargin: LookAndFeel.spacing.small
                rightMargin: LookAndFeel.spacing.small
            }

            spacing: LookAndFeel.spacing.small

            Item {
                Layout.alignment: Qt.AlignTop
                implicitWidth: root.iconSize
                implicitHeight: root.iconSize

                IconImage {
                    anchors.fill: parent

                    visible: root.icon !== ""
                    source: root.icon
                }

                // Bell for apps without an icon
                Label {
                    anchors.centerIn: parent

                    visible: root.icon === ""

                    fontSize: LookAndFeel.fontSize.huge
                    text: "\u{f009a}"
                    color: UserConfig.barHighlightColor
                }
            }

            ColumnLayout {
                Layout.fillWidth: true

                spacing: 0

                Label {
                    Layout.fillWidth: true

                    visible: text !== ""

                    elide: Text.ElideRight
                    fontSize: LookAndFeel.fontSize.normal * 0.8
                    text: root.appName
                    color: LookAndFeel.color.overlay_1
                }

                Label {
                    Layout.fillWidth: true

                    elide: Text.ElideRight
                    font.bold: true
                    text: root.summary
                }

                Label {
                    Layout.fillWidth: true

                    visible: text !== ""

                    wrapMode: Text.Wrap
                    maximumLineCount: 4
                    elide: Text.ElideRight
                    textFormat: Text.StyledText
                    text: root.body
                    color: LookAndFeel.color.subtext_1
                }
            }
        }
    }
}
