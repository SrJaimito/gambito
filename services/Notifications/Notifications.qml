pragma Singleton


import Quickshell
import Quickshell.Services.Notifications

import QtQuick

import qs.config


// Makes the shell the session's notification daemon. Every notification is
// kept (tracked) until it's read: clicked, dismissed, or closed by its app.
// A popup that merely times out leaves it unread
Singleton {
    id: root

    // Emitted for each new notification that should pop up, i.e. not while
    // Do Not Disturb is on
    signal received(Notification notification)

    // Newest first
    readonly property list<Notification> unread: server.trackedNotifications.values.slice().reverse()

    // Unread notifications grouped by app, the app with the newest one first:
    // [{ appName, icon, notifications }]
    readonly property var apps: {
        const groups = [];

        for (const n of root.unread) {
            const name = n.appName || n.summary;
            let group = groups.find(g => g.appName === name);

            if (!group) {
                group = { appName: name, icon: root.appIconFor(n) || root.iconFor(n), notifications: [] };
                groups.push(group);
            }

            group.notifications.push(n);
        }

        return groups;
    }

    // When each notification arrived (ms since the epoch), by id.
    // Notifications carry no timestamp
    readonly property var receivedAt: JSON.parse(persistent.receivedAt)

    // Mark as read
    function dismiss(n) {
        if (n?.tracked) {
            n.dismiss();
        }
    }

    // Run the notification's default action, if it has one, and mark it read
    function invoke(n) {
        if (!n) {
            return;
        }

        n.actions.find(a => a.identifier === "default")?.invoke();

        // Invoking already dismisses non resident notifications
        if (!n.resident) {
            root.dismiss(n);
        }
    }

    function clearAll() {
        // A copy, the tracked list shrinks with each dismissal and iterating
        // it directly skips every other one
        for (const n of server.trackedNotifications.values.slice()) {
            n.dismiss();
        }
    }

    // Transient notifications only matter while they're on screen
    function popupTimedOut(n) {
        if (n?.tracked && n.transient) {
            n.expire();
        }
    }

    // How long the popup stays, in ms, the app's own timeout if it gives one
    function timeout(n) {
        return n?.expireTimeout > 0 ? n.expireTimeout : 5000;
    }

    // Image specific to this notification (e.g. a contact's avatar), falling
    // back to its app's icon. Empty when there is neither
    function iconFor(n) {
        return n?.image || root.appIconFor(n);
    }

    function appIconFor(n) {
        if (!n) {
            return "";
        }

        const entry = DesktopEntries.byId(n.desktopEntry) ?? DesktopEntries.heuristicLookup(n.appName);

        return root.resolveIcon(n.appIcon) || root.resolveIcon(entry?.icon ?? "");
    }

    // Icon names are looked up in the icon theme, paths are used as they are
    function resolveIcon(icon) {
        if (icon === "") {
            return "";
        }

        if (icon.startsWith("/")) {
            return "file://" + icon;
        }

        if (icon.includes("://")) {
            return icon;
        }

        return Quickshell.iconPath(icon, true);
    }

    // Survives hot reloads along with the notifications themselves
    PersistentProperties {
        id: persistent

        reloadableId: "notifications"

        // As JSON, a JS object can't be carried over to the reloaded engine
        property string receivedAt: "{}"
    }

    NotificationServer {
        id: server

        // Keep the notifications across hot reloads
        keepOnReload: true

        persistenceSupported: true
        bodyMarkupSupported: true
        actionsSupported: true
        imageSupported: true

        onNotification: n => {
            n.tracked = true;

            // Kept ones are emitted again on every reload, but they've been
            // seen already
            if (n.lastGeneration) {
                return;
            }

            // Forget the ones already read while at it
            const receivedAt = {};
            for (const kept of server.trackedNotifications.values) {
                if (root.receivedAt[kept.id]) {
                    receivedAt[kept.id] = root.receivedAt[kept.id];
                }
            }
            receivedAt[n.id] = Date.now();
            persistent.receivedAt = JSON.stringify(receivedAt);

            if (!UserConfig.doNotDisturb) {
                root.received(n);
            }
        }
    }
}
