pragma Singleton


import Quickshell
import Quickshell.Networking

import QtQuick


// Thin adapter over Quickshell.Networking (NetworkManager over D-Bus), so the
// bar gets pushed updates instead of polling and parsing nmcli output.
Singleton {
    id: root

    readonly property NetworkDevice wiredDevice: Networking.devices.values.find(
        dev => dev.type === DeviceType.Wired && dev.connected) ?? null
    readonly property NetworkDevice wifiDevice: Networking.devices.values.find(
        dev => dev.type === DeviceType.Wifi && dev.connected) ?? null
    readonly property WifiNetwork wifiNetwork: wifiDevice?.networks.values.find(
        net => net.connected) ?? null

    // Wired wins when both are up, since that's what NetworkManager routes through.
    readonly property string type: wiredDevice ? "ethernet" : wifiDevice ? "wifi" : ""
    readonly property string wifiName: type === "wifi" ? (wifiNetwork?.name ?? "") : ""
    readonly property real signalStrength: wifiNetwork?.signalStrength ?? 0
}
