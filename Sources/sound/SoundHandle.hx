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

    function subscribeOnPlay(callback: Void->Void): Void;
    function subscribeOnPause(callback: Void->Void): Void;
    function subscribeOnStop(callback: Void->Void): Void;
    function subscribeOnFinish(callback: Void->Void): Void;

    function unsubscribeOnPlay(callback: Void->Void): Void;
    function unsubscribeOnPause(callback: Void->Void): Void;
    function unsubscribeOnStop(callback: Void->Void): Void;
    function unsubscribeOnFinish(callback: Void->Void): Void;
}
