pragma Singleton


import Quickshell
import Quickshell.Services.Pipewire


Singleton {
    id: root

    property PwNode sink: Pipewire.defaultAudioSink

    property bool isMuted: sink.audio.muted

    PwObjectTracker {
        objects: [sink]
    }

    function getVolume(): int {
        return Math.round(sink.audio.volume * 100);
    }

    function setVolume(volume) {
        sink.audio.volume = Math.round(volume) / 100;
    }
}

