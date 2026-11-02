pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property FontSize fontSize: FontSize {}
    readonly property FontFamily fontFamily: FontFamily {}

    readonly property Rounding rounding: Rounding {}
    readonly property Spacing spacing: Spacing {}

    readonly property bool darkMode: UserConfig.darkMode
    readonly property Color color: darkMode ? (darkPalettes[UserConfig.darkPalette] ?? darkPaletteFrappe) : lightPaletteLatte

    // The dark palettes to choose from, by the name stored in UserConfig. An
    // unknown name (hand-edited settings file) falls back to Frappé above
    readonly property var darkPalettes: ({
        "Frappé": darkPaletteFrappe,
        "Macchiato": darkPaletteMacchiato,
        "Mocha": darkPaletteMocha,
    })

    component FontSize: QtObject {
        readonly property int normal: 16
        readonly property int large: 20
        readonly property int larger: 24
        readonly property int huge: 30
    }

    component FontFamily: QtObject {
        readonly property string mono: "JetBrainsMono Nerd Font Mono"
        readonly property string propo: "JetBrainsMono Nerd Font propo"
    }

    component Rounding: QtObject {
        readonly property int small: 10
        readonly property int normal: 20
        readonly property int full: 1000
    }

    component Spacing: QtObject {
        readonly property int tiny: 5
        readonly property int small: 10
        readonly property int normal: 20
        readonly property int large: 30
        readonly property int huge: 40
    }

    component Color: QtObject {
        property color rosewater
        property color flamingo
        property color pink
        property color mauve
        property color red
        property color maroon
        property color peach
        property color yellow
        property color green
        property color teal
        property color sky
        property color sapphire
        property color blue
        property color lavender
        property color text
        property color subtext_1
        property color subtext_0
        property color overlay_2
        property color overlay_1
        property color overlay_0
        property color surface_2
        property color surface_1
        property color surface_0
        property color base
        property color mantle
        property color crust
    }

    // Light color theme based on Catppuccin Latte (https://catppuccin.com/palette)
    readonly property Color lightPaletteLatte: Color {
        rosewater: "#dc8a78"
        flamingo: "#dd7878"
        pink: "#ea76cb"
        mauve: "#8839ef"
        red: "#d20f39"
        maroon: "#e64553"
        peach: "#fe640b"
        yellow: "#df8e1d"
        green: "#40a02b"
        teal: "#179299"
        sky: "#04a5e5"
        sapphire: "#209fb5"
        blue: "#1e66f5"
        lavender: "#7287fd"
        text: "#4c4f69"
        subtext_1: "#5c5f77"
        subtext_0: "#6c6f85"
        overlay_2: "#7c7f93"
        overlay_1: "#8c8fa1"
        overlay_0: "#9ca0b0"
        surface_2: "#acb0be"
        surface_1: "#bcc0cc"
        surface_0: "#ccd0da"
        base: "#eff1f5"
        mantle: "#e6e9ef"
        crust: "#dce0e8"
    }

    // Dark color theme based on Catppuccin Frappé (https://catppuccin.com/palette)
    readonly property Color darkPaletteFrappe: Color {
        rosewater: "#f2d5cf"
        flamingo: "#eebebe"
        pink: "#f4b8e4"
        mauve: "#ca9ee6"
        red: "#e78284"
        maroon: "#ea999c"
        peach: "#ef9f76"
        yellow: "#e5c890"
        green: "#a6d189"
        teal: "#81c8be"
        sky: "#99d1db"
        sapphire: "#85c1dc"
        blue: "#8caaee"
        lavender: "#babbf1"
        text: "#c6d0f5"
        subtext_1: "#b5bfe2"
        subtext_0: "#a5adce"
        overlay_2: "#949cbb"
        overlay_1: "#838ba7"
        overlay_0: "#737994"
        surface_2: "#626880"
        surface_1: "#51576d"
        surface_0: "#414559"
        base: "#303446"
        mantle: "#292c3c"
        crust: "#232634"
    }

    // Dark color theme based on Catppuccin Macchiato (https://catppuccin.com/palette)
    readonly property Color darkPaletteMacchiato: Color {
        rosewater: "#f4dbd6"
        flamingo: "#f0c6c6"
        pink: "#f5bde6"
        mauve: "#c6a0f6"
        red: "#ed8796"
        maroon: "#ee99a0"
        peach: "#f5a97f"
        yellow: "#eed49f"
        green: "#a6da95"
        teal: "#8bd5ca"
        sky: "#91d7e3"
        sapphire: "#7dc4e4"
        blue: "#8aadf4"
        lavender: "#b7bdf8"
        text: "#cad3f5"
        subtext_1: "#b8c0e0"
        subtext_0: "#a5adcb"
        overlay_2: "#939ab7"
        overlay_1: "#8087a2"
        overlay_0: "#6e738d"
        surface_2: "#5b6078"
        surface_1: "#494d64"
        surface_0: "#363a4f"
        base: "#24273a"
        mantle: "#1e2030"
        crust: "#181926"
    }

    // Dark color theme based on Catppuccin Mocha (https://catppuccin.com/palette)
    readonly property Color darkPaletteMocha: Color {
        rosewater: "#f5e0dc"
        flamingo: "#f2cdcd"
        pink: "#f5c2e7"
        mauve: "#cba6f7"
        red: "#f38ba8"
        maroon: "#eba0ac"
        peach: "#fab387"
        yellow: "#f9e2af"
        green: "#a6e3a1"
        teal: "#94e2d5"
        sky: "#89dceb"
        sapphire: "#74c7ec"
        blue: "#89b4fa"
        lavender: "#b4befe"
        text: "#cdd6f4"
        subtext_1: "#bac2de"
        subtext_0: "#a6adc8"
        overlay_2: "#9399b2"
        overlay_1: "#7f849c"
        overlay_0: "#6c7086"
        surface_2: "#585b70"
        surface_1: "#45475a"
        surface_0: "#313244"
        base: "#1e1e2e"
        mantle: "#181825"
        crust: "#11111b"
    }
}

