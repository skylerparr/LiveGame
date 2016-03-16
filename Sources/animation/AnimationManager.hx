package animation;
interface AnimationManager {
    function queueAnimationUpdate(animation: AnimationController): Void;
    function dequeueAnimationUpdate(animation: AnimationController): Void;
}
