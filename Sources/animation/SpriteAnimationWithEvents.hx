package animation;
import core.ObjectCreator;
import util.MappedSubscriber;
class SpriteAnimationWithEvents extends SpriteAnimation implements AnimationWithEvents {
    public static inline var ON_ANIMATION_COMPLETE: String = "onAnimationComplete";

    @inject
    public var objectCreator: ObjectCreator;

    public var mappedSubscriber: MappedSubscriber;

    public function new() {
        super();
    }

    override public function init():Void {
        super.init();
        mappedSubscriber = objectCreator.createInstance(MappedSubscriber);
    }

    override public function dispose():Void {
        super.dispose();
        objectCreator.disposeInstance(mappedSubscriber);
        mappedSubscriber = null;
        objectCreator = null;
    }

    override public function nextFrame():Void {
        super.nextFrame();
        if(currentFrame == numFrames - 1) {
            mappedSubscriber.notify(ON_ANIMATION_COMPLETE, [this]);
        }
    }

    public function subscribeOnComplete(callback:AnimationWithEvents->Void):Void {
        mappedSubscriber.subscribe(ON_ANIMATION_COMPLETE, callback);
    }

    public function unsubscribeOnComplete(callback:AnimationWithEvents->Void):Void {
        mappedSubscriber.unsubscribe(ON_ANIMATION_COMPLETE, callback);
    }
}
