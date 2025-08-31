import Quickshell
import Quickshell.Io

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

    Process {
        id: lock

        command: ["hyprctl", "dispatch", "exec", "hyprlock"]
        running: false
    }

    Process {
        id: exit

        command: ["hyprctl", "dispatch", "exit"]
        running: false
    }

    Process {
        id: shutdown

        command: ["shutdown", "now"]
        running: false
    }
}

