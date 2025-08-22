pragma Singleton


import Quickshell
import Quickshell.Services.Pipewire


Singleton {
    id: root

    property PwNode sink: Pipewire.defaultAudioSink

    property int volume: parseVolumePercentage(sink.audio.volume)
    property bool isMuted: sink.audio.muted

    PwObjectTracker {
        objects: [sink]
    }

    function parseVolumePercentage(volume): int {
        return Math.round(volume * 100);
    }
}

