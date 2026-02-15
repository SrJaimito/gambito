pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property FontSize fontSize: FontSize {}
    readonly property FontFamily fontFamily: FontFamily {}

    readonly property Rounding rounding: Rounding {}
    readonly property Spacing spacing: Spacing {}

    readonly property bool darkMode: false
    readonly property Color color: darkMode ? darkPalette : lightPalette

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
        property string rosewater
        property string flamingo
        property string pink
        property string mauve
        property string red
        property string maroon
        property string peach
        property string yellow
        property string green
        property string teal
        property string sky
        property string sapphire
        property string blue
        property string lavender
        property string text
        property string subtext_1
        property string subtext_0
        property string overlay_2
        property string overlay_1
        property string overlay_0
        property string surface_2
        property string surface_1
        property string surface_0
        property string base
        property string mantle
        property string crust
    }

    // Light color theme based on Catppuccin Latte (https://catppuccin.com/palette)
    readonly property Color lightPalette: Color {
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

    // Dark color theme based on Catppuccin Mocha (https://catppuccin.com/palette)
    readonly property Color darkPalette: Color {
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
}

