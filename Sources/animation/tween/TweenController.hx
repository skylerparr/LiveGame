package animation.tween;
import core.BaseObject;
interface TweenController extends BaseObject {
    function addTween(tween: Tween): Void;
    function removeTween(tween: Tween): Void;
    function pauseAll(): Void;
    function resumeAll(): Void;
    function stopAll(): Void;
}
