pragma Singleton


import Quickshell
import Quickshell.Services.Pipewire


Singleton {
    id: root

    property PwNode sink: Pipewire.defaultAudioSink

    // The default sink can be null, e.g. while PipeWire is starting up
    property bool isMuted: sink?.audio?.muted ?? false

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
}

