pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property FontSize fontSize: FontSize {}
    readonly property FontFamily fontFamily: FontFamily {}

    readonly property Rounding rounding: Rounding {}
    readonly property Spacing spacing: Spacing {}

    readonly property Color color: Color {}

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
        readonly property int full: 1000
    }

    component Spacing: QtObject {
        readonly property int small: 10
        readonly property int normal: 20
        readonly property int large: 30
        readonly property int hueg: 40
    }

    component Color: QtObject {
        readonly property string rosewater: "#f2d5cf"
        readonly property string flamingo: "#eebebe"
        readonly property string pink: "#f4b8e4"
        readonly property string mauve: "#ca9ee6"
        readonly property string red: "#e78284"
        readonly property string maroon: "#ea999c"
        readonly property string peach: "#ef9f76"
        readonly property string yellow: "#e5c890"
        readonly property string green: "#a6d189"
        readonly property string teal: "#81c8be"
        readonly property string sky: "#99d1db"
        readonly property string sapphire: "#85c1dc"
        readonly property string blue: "#8caaee"
        readonly property string lavender: "#babbf1"
        readonly property string text: "#c6d0f5"
        readonly property string subtext_1: "#b5bfe2"
        readonly property string subtext_0: "#a5adce"
        readonly property string overlay_2: "#949cbb"
        readonly property string overlay_1: "#838ba7"
        readonly property string overlay_0: "#737994"
        readonly property string surface_2: "#626880"
        readonly property string surface_1: "#51576d"
        readonly property string surface_0: "#414559"
        readonly property string base: "#303446"
        readonly property string mantle: "#292c3c"
        readonly property string crust: "#232634"
    }
}

