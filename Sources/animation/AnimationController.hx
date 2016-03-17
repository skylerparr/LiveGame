package animation;
import core.BaseObject;
interface AnimationController extends BaseObject {
    var animation(get, set): Animation;
    var loops(get, set): Bool;

    function start(): Void;
    function stop(): Void;
    function pause(): Void;
    function resume(): Void;

    function startHandler(handler: Void->Void): Void;
    function stopHandler(handler: Void->Void): Void;

    function removeStartHandler(handler: Void->Void): Void;
    function removeStopHandler(handler: Void->Void): Void;
}
