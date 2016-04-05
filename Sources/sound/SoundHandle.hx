package sound;
import core.BaseObject;
interface SoundHandle extends BaseObject {
    var volume(get, set): Float;
    var position(get, set): Float;
    var length(get, null): Float;

    function play(): Void;
    function pause(): Void;
    function resume(): Void;
    function stop(): Void;

    function onPlay(callback: Void->Void): Void;
    function onPause(callback: Void->Void): Void;
    function onStop(callback: Void->Void): Void;
    function onFinish(callback: Void->Void): Void;
}
