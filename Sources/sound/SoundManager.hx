package sound;
import core.BaseObject;
interface SoundManager extends BaseObject {
    var masterVolume(get, set): Float;

    function playAll(): Void;
    function stopAll(): Void;
    function pauseAll(): Void;
    function resumeAll(): Void;

    function addSoundLayer(name: String, soundLayer: SoundLayer): Void;
    function getSoundLayerByName(name: String): SoundLayer;
    function removeSoundLayerByName(name: String): Void;
}
