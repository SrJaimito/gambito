//@ pragma ShellId gambito

import Quickshell

import QtQuick

import qs.config
import qs.services.Monitors
import qs.bars.Bar
import qs.widgets.MainMenu
import qs.widgets.AudioMenu
import qs.widgets.NetworkMenu
import qs.widgets.SettingsWindow
import qs.widgets.Osd
import qs.widgets.NotificationPopup
import qs.widgets.NotificationMenu


Scope {
    id: root

    readonly property int topBarHeight: 40
    readonly property int topBarBorderWidth: 10
    readonly property int topBarTransitionAngle: 60
    readonly property int topBarGroupTransitionRadius: 15

    // Room around the bar and menus for their shadows to be drawn into
    readonly property int shadowMargin: LookAndFeel.spacing.huge

    // Windows without an explicit screen open on whichever monitor has focus
    // when they are mapped, so pin the bar and its menus to the primary one
    readonly property ShellScreen screen: Monitors.primaryScreen

    // Bar the menus hang from
    readonly property Bar topBar: bars.instances.find(b => b.primary) ?? null

    // Every screen gets a bar, showing only its workspaces unless it's the
    // primary screen. The model doesn't depend on which screen is primary, so
    // changing it never adds or removes windows, see Bar
    Variants {
        id: bars

        model: Quickshell.screens

        delegate: Bar {
            required property ShellScreen modelData

            screen: modelData
            primary: modelData === root.screen

            barHeight: root.topBarHeight
            topBorderWidth: root.topBarBorderWidth

            topAngle: root.topBarTransitionAngle

            topGroupTransitionRadius: root.topBarGroupTransitionRadius

            shadowMargin: root.shadowMargin
        }
    }

    MainMenu {
        screen: root.screen

        bar: root.topBar
        barHeight: root.topBarHeight
        barBorderWidth: root.topBarBorderWidth
        barGroupWidth: root.topBar?.leftGroupWidth ?? 0
        barAngle: root.topBarTransitionAngle
        barTransitionRadius: root.topBarGroupTransitionRadius
        shadowMargin: root.shadowMargin
    }

    AudioMenu {
        screen: root.screen

        bar: root.topBar
        barHeight: root.topBarHeight
        barBorderWidth: root.topBarBorderWidth
        barGroupWidth: root.topBar?.rightGroupWidth ?? 0
        barAngle: root.topBarTransitionAngle
        barTransitionRadius: root.topBarGroupTransitionRadius
        shadowMargin: root.shadowMargin
    }

    NetworkMenu {
        screen: root.screen

        bar: root.topBar
        barHeight: root.topBarHeight
        barBorderWidth: root.topBarBorderWidth
        barGroupWidth: root.topBar?.rightGroupWidth ?? 0
        barAngle: root.topBarTransitionAngle
        barTransitionRadius: root.topBarGroupTransitionRadius
        shadowMargin: root.shadowMargin
    }

    NotificationMenu {
        screen: root.screen

        bar: root.topBar
        barHeight: root.topBarHeight
        barBorderWidth: root.topBarBorderWidth
        barGroupWidth: root.topBar?.notificationGroupWidth ?? 0
        barAngle: root.topBarTransitionAngle
        barTransitionRadius: root.topBarGroupTransitionRadius
        shadowMargin: root.shadowMargin
    }

    // Also what starts the notification server, as soon as the shell does
    NotificationPopup {
        screen: root.screen

        barHeight: root.topBarHeight
        shadowMargin: root.shadowMargin
    }

    SettingsWindow {
        screen: root.screen

        shadowMargin: root.shadowMargin
    }

    Osd {
        screen: root.screen

        shadowMargin: root.shadowMargin
    }
}
