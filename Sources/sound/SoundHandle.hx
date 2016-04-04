package sound;
interface SoundHandle {
    var volume(get, set): Float;
    var position(get, set): Float;
    var length(get, null): Float;

    function onPlay(callback: SoundHandle->Void): Void;
    function onPause(callback: SoundHandle->Void): Void;
    function onStop(callback: SoundHandle->Void): Void;
    function onFinish(callback: SoundHandle->Void): Void;
}
