pragma Singleton


import Quickshell
import Quickshell.Services.UPower


Singleton {
    id: root

    property UPowerDevice device: UPower.displayDevice

    // The display device can be null, e.g. while UPower is starting up
    property bool hasBattery: device?.type === UPowerDeviceType.Battery
    property int batteryLevel: getBatteryLevel()
    property bool isCharging: isChargingOrCharged()

    function getBatteryLevel() {
        return Math.round((device?.percentage ?? 0) * 100);
    }

    function isChargingOrCharged() {
        return device?.state === UPowerDeviceState.FullyCharged
                || device?.state === UPowerDeviceState.Charging;
    }
}

