pragma Singleton


import Quickshell
import Quickshell.Services.Pipewire


Singleton {
    id: root

    property PwNode sink: Pipewire.defaultAudioSink

    // The default sink can be null, e.g. while PipeWire is starting up
    property bool isMuted: sink?.audio?.muted ?? false

    // Outputs the user can pick from: real (or virtual) sinks, not the
    // per-application playback streams PipeWire also reports as sinks
    readonly property list<PwNode> sinks: Pipewire.nodes.values.filter(node => node.isSink && !node.isStream && node.audio)

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }

    function getVolume(): int {
        return Math.round((sink?.audio?.volume ?? 0) * 100);
    }

    function setVolume(volume) {
        if (!sink?.audio) {
            return;
        }

        sink.audio.volume = Math.round(volume) / 100;
    }

    // Changing the preferred sink makes PipeWire switch the default one, which
    // `sink` follows, so the volume slider and OSD move to it on their own
    function setSink(node) {
        Pipewire.preferredDefaultAudioSink = node;
    }

    // What a sink plays through: "monitor", "headphones", "speakers" or
    // "other". Drivers fill the hints differently, so several are checked
    function sinkKind(node): string {
        const props = node?.properties ?? {};
        const icon = props["device.icon_name"] ?? props["device.icon-name"] ?? "";
        const form = props["device.form-factor"] ?? "";
        const profile = props["device.profile.name"] ?? "";

        if (icon === "video-display" || /hdmi|displayport/i.test(profile)) {
            return "monitor";
        }
        if (/head(phone|set)/.test(form) || icon.includes("headphone")) {
            return "headphones";
        }
        if (form === "internal" || form === "speaker" || icon.includes("speaker")) {
            return "speakers";
        }
        return "other";
    }

    // node.description is "<sound card> <output> (<channels>)", far too long
    // for a menu, so build a short name from the output kind instead
    function sinkName(node): string {
        if (!node) {
            return "";
        }

        const props = node.properties ?? {};
        const nick = node.nickname || "";
        const bus = props["device.bus"] ?? "";

        // External devices: their own name is what the user recognises
        if (bus === "bluetooth") {
            return node.description || nick || node.name;
        }
        if (bus === "usb") {
            return nick || node.description || node.name;
        }

        switch (sinkKind(node)) {
        case "monitor": {
            // ALSA numbers HDMI/DP outputs ("HDMI 2"), with no link to which
            // monitor is behind each one
            const number = nick.match(/\d+/);
            return number ? `Monitor ${number[0]}` : "Monitor";
        }
        case "headphones":
            return "Headphones";
        case "speakers":
            return "Built-in speakers";
        default:
            return nick || node.description || node.name;
        }
    }
}
