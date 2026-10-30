import Quickshell
import Quickshell.Io

import QtQuick
import QtQuick.Layouts

import qs.components.CircleButton
import qs.config


RowLayout {
    CircleButton {
        text: "\uf456"
        onClicked: {
            UserControl.mainMenuIsVisible = false;
            lock.running = true;
        }
    }

    CircleButton {
        text: "\u{f0fc5}"
        onClicked: {
            UserControl.mainMenuIsVisible = false;
            exit.running = true;
        }
    }

    CircleButton {
        text: "\uf011"
        onClicked: {
            UserControl.mainMenuIsVisible = false;
            shutdown.running = true;
        }
    }

    // Separate the session buttons from the settings one
    Rectangle {
        Layout.fillHeight: true
        Layout.topMargin: 0
        Layout.bottomMargin: 0
        implicitWidth: 2

        radius: LookAndFeel.rounding.full

        color: LookAndFeel.color.surface_2
    }

    // Do Not Disturb, drawn inverted while on. Leaves the menu open so the
    // change can be seen
    CircleButton {
        text: UserConfig.doNotDisturb ? "\u{f009b}" : "\u{f009a}"

        fgColor: UserConfig.doNotDisturb ? UserConfig.barHighlightColor : LookAndFeel.color.crust
        bgColor: UserConfig.doNotDisturb ? LookAndFeel.color.surface_0 : UserConfig.barHighlightColor

        onClicked: UserConfig.setDoNotDisturb(!UserConfig.doNotDisturb)
    }

    CircleButton {
        text: "\uf013"
        onClicked: {
            UserControl.mainMenuIsVisible = false;
            UserControl.settingsWindowIsVisible = true;
        }
    }

    // Hyprland's Lua config turns `hyprctl dispatch <args>` into `hl.dispatch(<args>)`,
    // so the argument must be a Lua dispatcher call, not the old `exec hyprlock` syntax
    Process {
        id: lock

        command: ["hyprctl", "dispatch", 'hl.dsp.exec_cmd("hyprlock")']
        running: false
    }

    Process {
        id: exit

        command: ["hyprctl", "dispatch", "hl.dsp.exit()"]
        running: false
    }

    Process {
        id: shutdown

        command: ["shutdown", "now"]
        running: false
    }
}

