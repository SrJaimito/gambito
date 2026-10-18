import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components.SettingRow
import qs.components.Toggle
import qs.components.ColorChoice
import qs.components.WallpaperChoice
import qs.services.Wallpaper


ColumnLayout {
    id: root

    spacing: LookAndFeel.spacing.normal

    SettingRow {
        Layout.fillWidth: true

        title: "Dark mode"
        description: "Use the dark color palette"

        Toggle {
            checked: UserConfig.darkMode

            handler: (checked) => {
                UserConfig.setDarkMode(checked);
            }
        }
    }

    SettingRow {
        Layout.fillWidth: true

        title: "Accent color"
        description: "Highlight color used across the bars and menus"

        ColorChoice {
            names: [
                "rosewater", "flamingo", "pink", "mauve", "red", "maroon", "peach",
                "yellow", "green", "teal", "sky", "sapphire", "blue", "lavender",
            ]

            columns: 7
            rows: 2

            selected: UserConfig.highlightColor

            handler: (name) => {
                UserConfig.setHighlightColor(name);
            }
        }
    }

    // The carousel needs the full width, so it goes under its row instead of
    // in the row's control slot
    ColumnLayout {
        Layout.fillWidth: true

        spacing: LookAndFeel.spacing.small

        SettingRow {
            Layout.fillWidth: true

            title: "Wallpaper"
            description: "Picture shown behind your windows"
        }

        WallpaperChoice {
            Layout.fillWidth: true

            folder: Wallpaper.folder
            selected: Wallpaper.current

            handler: (path) => {
                Wallpaper.set(path);
            }
        }
    }
}
