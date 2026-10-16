import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.SettingRow
import qs.components.Dropdown
import qs.components.Label
import qs.components.TextButton
import qs.services.Monitors


ColumnLayout {
    id: root

    // Arrangement being edited, in logical pixels, applied with the button.
    // Reset whenever the real monitors change: plugged, unplugged or moved
    property var draft: []

    readonly property string liveGeometry: JSON.stringify(Monitors.monitors)
    onLiveGeometryChanged: root.resetDraft()
    Component.onCompleted: root.resetDraft()

    readonly property bool modified: root.draft.some(d => {
        const live = Monitors.monitors.find(m => m.name === d.name);
        return !live || live.x !== d.x || live.y !== d.y;
    })

    function resetDraft() {
        root.draft = Monitors.monitors.map(m => Object.assign({}, m));
    }

    // Place a dropped monitor: snap it flush to the closest nearby edges,
    // refuse it on top of another one and shift everything so the
    // arrangement starts at 0,0
    function drop(index, x, y, threshold) {
        const moved = root.draft[index];
        const others = root.draft.filter((_, i) => i !== index);

        // Closest candidate within the threshold, if any
        const snap = (value, candidates) => {
            let best = value;
            let bestDistance = threshold;
            for (const candidate of candidates) {
                const distance = Math.abs(candidate - value);
                if (distance < bestDistance) {
                    best = candidate;
                    bestDistance = distance;
                }
            }
            return best;
        };

        // Next to another monitor, or lined up with one of its sides. The
        // QML engine has no Array.flatMap, so flatten with concat
        x = snap(x, [].concat(...others.map(o => [o.x - moved.width, o.x + o.width, o.x, o.x + o.width - moved.width])));
        y = snap(y, [].concat(...others.map(o => [o.y - moved.height, o.y + o.height, o.y, o.y + o.height - moved.height])));

        x = Math.round(x);
        y = Math.round(y);

        const overlaps = others.some(o =>
            x < o.x + o.width && x + moved.width > o.x && y < o.y + o.height && y + moved.height > o.y);
        if (overlaps) {
            return;
        }

        const placed = root.draft.map((m, i) => i === index ? Object.assign({}, m, { x: x, y: y }) : m);

        const minX = Math.min(...placed.map(m => m.x));
        const minY = Math.min(...placed.map(m => m.y));
        root.draft = placed.map(m => Object.assign({}, m, { x: m.x - minX, y: m.y - minY }));
    }

    spacing: LookAndFeel.spacing.normal

    SettingRow {
        Layout.fillWidth: true

        // The dropdown unfolds over the canvas below
        z: 1

        title: "Primary monitor"
        description: "Monitor showing the main bar and its menus"

        Dropdown {
            options: Monitors.monitors.map(m => m.name)
            selected: Monitors.primaryName

            handler: (name) => {
                Monitors.setPrimary(name);
            }
        }
    }

    Rectangle {
        id: canvas

        // Room left around the arrangement
        readonly property real padding: LookAndFeel.spacing.normal

        readonly property real minX: Math.min(...root.draft.map(m => m.x))
        readonly property real minY: Math.min(...root.draft.map(m => m.y))
        readonly property real boundsWidth: Math.max(...root.draft.map(m => m.x + m.width)) - canvas.minX
        readonly property real boundsHeight: Math.max(...root.draft.map(m => m.y + m.height)) - canvas.minY

        // Canvas pixels per logical pixel, fitting the whole arrangement
        readonly property real factor: root.draft.length === 0 ? 1 : Math.min(
            (canvas.width - 2 * canvas.padding) / canvas.boundsWidth,
            (canvas.height - 2 * canvas.padding) / canvas.boundsHeight)

        // Where the arrangement starts, to center it
        readonly property real originX: (canvas.width - canvas.boundsWidth * canvas.factor) / 2
        readonly property real originY: (canvas.height - canvas.boundsHeight * canvas.factor) / 2

        Layout.fillWidth: true
        implicitHeight: 260

        radius: LookAndFeel.rounding.normal

        color: LookAndFeel.color.mantle

        Repeater {
            model: root.draft

            delegate: Rectangle {
                id: monitor

                required property var modelData
                required property int index

                readonly property bool isPrimary: modelData.name === Monitors.primaryName

                // Offset of an ongoing drag. Kept apart from the position so
                // the bindings below survive dragging
                property real dragX: 0
                property real dragY: 0

                x: canvas.originX + (modelData.x - canvas.minX) * canvas.factor + monitor.dragX
                y: canvas.originY + (modelData.y - canvas.minY) * canvas.factor + monitor.dragY
                width: modelData.width * canvas.factor
                height: modelData.height * canvas.factor

                // Raise the one being dragged over the others
                z: dragArea.pressed ? 1 : 0

                radius: LookAndFeel.rounding.small

                color: dragArea.pressed ? LookAndFeel.color.surface_2
                     : dragArea.containsMouse ? LookAndFeel.color.surface_1
                     : LookAndFeel.color.surface_0
                border.width: 2
                border.color: monitor.isPrimary ? UserConfig.barHighlightColor : LookAndFeel.color.overlay_0

                ColumnLayout {
                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        margins: LookAndFeel.spacing.small
                    }

                    spacing: 0

                    Label {
                        Layout.fillWidth: true

                        text: monitor.modelData.connector
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                        color: monitor.isPrimary ? UserConfig.barHighlightColor : LookAndFeel.color.text
                    }

                    Label {
                        Layout.fillWidth: true

                        text: monitor.modelData.name
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                        fontSize: LookAndFeel.fontSize.normal - 4
                        color: LookAndFeel.color.subtext_0
                    }

                    Label {
                        Layout.fillWidth: true

                        text: monitor.modelData.resolution
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                        fontSize: LookAndFeel.fontSize.normal - 4
                        color: LookAndFeel.color.subtext_0
                    }
                }

                MouseArea {
                    id: dragArea

                    property point pressPoint

                    anchors.fill: parent

                    // Keep the page's Flickable from taking over vertical drags
                    preventStealing: true

                    hoverEnabled: true
                    cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor

                    onPressed: (mouse) => {
                        dragArea.pressPoint = mapToItem(canvas, mouse.x, mouse.y);
                    }

                    onPositionChanged: (mouse) => {
                        if (!pressed) {
                            return;
                        }

                        const point = mapToItem(canvas, mouse.x, mouse.y);
                        monitor.dragX = point.x - dragArea.pressPoint.x;
                        monitor.dragY = point.y - dragArea.pressPoint.y;
                    }

                    onReleased: {
                        const x = monitor.modelData.x + monitor.dragX / canvas.factor;
                        const y = monitor.modelData.y + monitor.dragY / canvas.factor;

                        monitor.dragX = 0;
                        monitor.dragY = 0;

                        // Snap within a fixed distance on screen, whatever the zoom
                        root.drop(monitor.index, x, y, 15 / canvas.factor);
                    }
                }
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true

        spacing: LookAndFeel.spacing.normal

        Label {
            Layout.fillWidth: true

            text: "Drag the monitors to arrange them"
            wrapMode: Text.WordWrap
            fontSize: LookAndFeel.fontSize.normal - 3
            color: LookAndFeel.color.subtext_0
        }

        TextButton {
            text: "Reset"

            enabled: root.modified
            onClicked: root.resetDraft()
        }

        TextButton {
            text: "Apply"

            enabled: root.modified
            onClicked: Monitors.applyPositions(root.draft)
        }
    }
}
