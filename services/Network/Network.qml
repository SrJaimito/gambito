pragma Singleton


import Quickshell
import Quickshell.Io

import QtQuick


Singleton {
    id: root

    property string type: ""
    property string wifiName: ""

    Process {
        id: getCurrentConnectionType

        command: ["nmcli", "-g", "TYPE,STATE", "dev", "status"]
        running: true
        
        stdout: StdioCollector {
            onStreamFinished: {
                let type = ""

                const devices = this.text.split("\n").filter(dev => dev.length > 0);
                for (let device of devices) {
                    const info = device.split(":");
                    const type_info = info[0];
                    const state_info = info[1];

                    if (state_info === "connected") {
                        type = `${type_info}`;
                        if (type === "ethernet") {
                            break;
                        }
                    }
                }

                root.type = type;

                if (root.type === "wifi") {
                    getCurrentWifiName.running = true;
                }
            }
        }
    }

    Process {
        id: getCurrentWifiName

        command: ["nmcli", "-g", "ACTIVE,SSID", "dev", "wifi"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                const wifi_conns = this.text.split("\n").filter(info => info.length > 0);
                for (let wifi of wifi_conns) {
                    const info = wifi.split(":");
                    if (info[0] === "yes") {
                        root.wifiName = info[1];
                    }
                }
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: getCurrentConnectionType.running = true
    }
}

