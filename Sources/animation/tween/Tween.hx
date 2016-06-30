package animation.tween;
import core.BaseObject;
interface Tween extends BaseObject {
    function to(target: Dynamic, time: UInt, properties: Dynamic): TweenTarget;
    function stop(): Void;
    function pause(): Void;
    function resume(): Void;
    function reset(): Void;

    function update(): Void;
}
