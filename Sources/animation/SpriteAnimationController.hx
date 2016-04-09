package animation;
import core.ObjectCreator;
import util.MappedSubscriber;
import constants.EventNames;
import util.Subscriber;
class SpriteAnimationController implements AnimationController {

    private static inline var START_ANIMATION: String = "startAnimation";
    private static inline var STOP_ANIMATION: String = "stopAnimation";

    @inject
    public var animationManager: AnimationManager;
    @inject
    public var objectCreator: ObjectCreator;

    @:isVar
    public var animation(get, set):Animation;

    @:isVar
    public var loops(get, set):Bool;

    private var running:Bool = false;
    private var paused: Bool = false;

    public var animationSubscriber: MappedSubscriber;

    public function get_animation():Animation {
        return animation;
    }

    public function set_animation(value:Animation) {
        return this.animation = value;
    }

    public function get_loops():Bool {
        return loops;
    }

    public function set_loops(value:Bool) {
        return this.loops = value;
    }

    public function new() {
    }

    public function init():Void {
        animationSubscriber = objectCreator.createInstance(MappedSubscriber);
    }

    public function dispose():Void {
        animationManager.dequeueAnimationUpdate(this);
        objectCreator.disposeInstance(animationSubscriber);
        objectCreator = null;
        animationManager = null;
        animation = null;
        animationSubscriber = null;
    }

    public function start():Void {
        if(running) {
            return;
        }
        running = true;
        animation.setFrame(0);
        animationManager.queueAnimationUpdate(this);
        animationSubscriber.notify(START_ANIMATION, null);
    }

    public function stop():Void {
        if(!running) {
            return;
        }
        running = false;
        animationManager.dequeueAnimationUpdate(this);
        animationSubscriber.notify(STOP_ANIMATION, null);
    }

    public function pause():Void {
        if(!running || paused) {
            return;
        }
        paused = true;
        animationManager.dequeueAnimationUpdate(this);
    }

    public function resume():Void {
        if(running && !paused) {
            return;
        }
        paused = false;
        animationManager.queueAnimationUpdate(this);
    }

    public function startHandler(handler:Void->Void):Void {
        animationSubscriber.subscribe(START_ANIMATION, handler);
    }

    public function stopHandler(handler:Void->Void):Void {
        animationSubscriber.subscribe(STOP_ANIMATION, handler);
    }

    public function removeStartHandler(handler:Void->Void):Void {
        animationSubscriber.unsubscribe(START_ANIMATION, handler);
    }

    public function removeStopHandler(handler:Void->Void):Void {
        animationSubscriber.unsubscribe(STOP_ANIMATION, handler);
    }

}
