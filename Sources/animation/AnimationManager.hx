package animation;
import core.BaseObject;
interface AnimationManager extends BaseObject {
    function queueAnimationUpdate(animation: AnimationController): Void;
    function dequeueAnimationUpdate(animation: AnimationController): Void;
}
