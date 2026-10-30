pragma Singleton


import Quickshell
import Quickshell.Widgets


Singleton {
    id: root

    readonly property date date: clock.date

    readonly property string dateText: Qt.formatDateTime(clock.date, "ddd MMM d")
    readonly property string timeText: Qt.formatDateTime(clock.date, "hh:mm")

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}

