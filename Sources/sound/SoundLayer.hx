package sound;
import core.BaseObject;
interface SoundLayer extends BaseObject {
    var volume(get, set): Float;
    var allSounds(get, null): Array<SoundHandle>;

    function play(): Void;
    function pause(): Void;
    function resume(): Void;
    function stop(): Void;

    function addSound(sound: SoundHandle): Void;
    function removeSound(sound: SoundHandle): Void;
    function removeAll(): Void;

    function subscribeToVolumeChange(callback: SoundLayer->Void): Void;
    function unsubscribeFromVolumeChange(callback: SoundLayer->Void): Void;
}
