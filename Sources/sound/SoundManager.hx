package sound;
interface SoundManager {
    var masterVolume(get, set): Float;

    function stopAll(): Void;
    function pauseAll(): Void;
    function resumeAll(): Void;

    function addSoundLayer(name: String, soundLayer: SoundLayer): Void;
    function getSoundLayerByName(name: String): SoundLayer;
}
