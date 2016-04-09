package animation;
import util.Subscriber;
class SubscribedAnimationManager implements AnimationManager {

    @inject
    public var subscriber: Subscriber;

    public var animations: Map<AnimationController, UInt>;

    @:isVar
    public var eventName(get, set): String;

    public function get_eventName():String {
        return eventName;
    }

    public function set_eventName(value:String) {
        if(eventName != null) {
            if(value == null) {
                if(subscriber != null) {
                    subscriber.unsubscribe(this.eventName, this.onEvent);
                }
                this.eventName = value;
            }
            return eventName;
        }
        this.eventName = value;
        subscriber.subscribe(this.eventName, this.onEvent);
        return eventName;
    }

    public function new() {
    }

    public function init():Void {
        animations = new Map<AnimationController, UInt>();
    }

    public function dispose():Void {
        subscriber.unsubscribe(eventName, this.onEvent);
        subscriber = null;
        animations = null;
        eventName = null;
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

