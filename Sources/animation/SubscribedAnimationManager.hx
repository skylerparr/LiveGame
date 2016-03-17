package animation;
import util.Subscriber;
class SubscribedAnimationManager implements AnimationManager {

    @inject
    public var subscriber: Subscriber;

    public var animations: Map<AnimationController, UInt>;

    private var eventName: String;

    public function new(eventName: String) {
        this.eventName = eventName;
    }

    public function init():Void {
        subscriber.subscribe(this.eventName, this.onEvent);
        animations = new Map<AnimationController, UInt>();
    }

    public function dispose():Void {
    }

    public function onEvent():Void {
        var currentTime: UInt = getTime();
        for(animationController in animations.keys()) {
            var animation: Animation = animationController.animation;
            var prevTime: UInt = animations.get(animationController);
            var animationFrameTime: UInt = animation.frameTime + prevTime;
            if(animationFrameTime <= currentTime) {
                animation.nextFrame();
                animations.set(animationController, currentTime);
            }
        }
    }

    public function queueAnimationUpdate(animation:AnimationController):Void {
        animations.set(animation, getTime());
    }

    public function dequeueAnimationUpdate(animation:AnimationController):Void {
        animations.remove(animation);
    }

    public inline function getTime(): UInt {
        #if test
        return 0;
        #else
        return util.Timer.now();
        #end
    }
}

