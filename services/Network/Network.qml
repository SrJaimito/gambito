pragma Singleton


import Quickshell
import Quickshell.Networking

import QtQuick


// Thin adapter over Quickshell.Networking (NetworkManager over D-Bus), so the
// bar gets pushed updates instead of polling and parsing nmcli output.
// Networking types stay in here: importing Quickshell.Networking next to this
// service makes `Network` resolve to its type instead of this singleton
Singleton {
    id: root

    // The adapters, whether connected or not, for the network menu
    readonly property NetworkDevice wiredAdapter: Networking.devices.values.find(
        dev => dev.type === DeviceType.Wired) ?? null
    readonly property NetworkDevice wifiAdapter: Networking.devices.values.find(
        dev => dev.type === DeviceType.Wifi) ?? null

    readonly property NetworkDevice wiredDevice: wiredAdapter?.connected ? wiredAdapter : null
    readonly property NetworkDevice wifiDevice: wifiAdapter?.connected ? wifiAdapter : null
    readonly property WifiNetwork wifiNetwork: wifiDevice?.networks.values.find(
        net => net.connected) ?? null

    // Wired wins when both are up, since that's what NetworkManager routes through.
    readonly property string type: wiredDevice ? "ethernet" : wifiDevice ? "wifi" : ""
    readonly property string wifiName: type === "wifi" ? (wifiNetwork?.name ?? "") : ""
    readonly property real signalStrength: wifiNetwork?.signalStrength ?? 0

    // Networks only show up here once an access point for them is seen, so
    // filtering on saved profiles leaves the reachable ones we can connect to
    readonly property list<WifiNetwork> knownWifiNetworks: (wifiAdapter?.networks.values ?? [])
        .filter(net => net.known)
        .sort((a, b) => (b.connected - a.connected) || (b.signalStrength - a.signalStrength))

    readonly property bool wiredHasLink: wiredAdapter?.hasLink ?? false
    // Typed loosely: `Network` here would be this singleton, not the Networking type
    readonly property QtObject wiredNetwork: wiredAdapter?.network ?? null

    readonly property bool wifiEnabled: Networking.wifiEnabled

    function setWifiEnabled(enabled) {
        Networking.wifiEnabled = enabled;
    }

    // Keep scanning only while someone is looking at the list
    function setScanning(enabled) {
        if (root.wifiAdapter) {
            root.wifiAdapter.scannerEnabled = enabled;
        }
    }

    // Connect to a network, or disconnect from it if it's the active one
    function toggle(network) {
        if (network.connected) {
            network.disconnect();
        } else {
            network.connect();
        }
    }
}
