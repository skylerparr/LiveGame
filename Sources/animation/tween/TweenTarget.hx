package animation.tween;
import core.BaseObject;
interface TweenTarget extends BaseObject {

    var easeFunction(get, null): Float->Float->Float->Float->Float;
    var beginFunction(get, null): Tween->Void;
    var updateFunction(get, null): Tween->Void;
    var completeFunction(get, null): Tween->Void;
    var delayValue(get, null): Int;

    function ease(easing: Float->Float->Float->Float->Float): TweenTarget;
    function delay(time: Int): TweenTarget;
    function onBegin(tween: Tween->Void): TweenTarget;
    function onUpdate(tween: Tween->Void): TweenTarget;
    function onComplete(tween: Tween->Void): TweenTarget;
}
