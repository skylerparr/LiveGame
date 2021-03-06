package animation.tween;
import animation.tween.target.SimpleTweenTarget;
import util.Timer;
import core.ObjectCreator;
class SimpleTween implements Tween {

    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var tweenController: TweenController;

    public var startTime: UInt;
    public var duration: UInt;

    public var originalProperties: Dynamic;
    public var originalTargetProperties: Dynamic;

    public var tweenTarget: TweenTarget;
    public var started: Bool;
    public var target: Dynamic;

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
        stop();
        objectCreator.disposeInstance(tweenTarget);
        tweenTarget = null;
        started = false;
        originalProperties = null;
        target = null;
        originalTargetProperties = null;
        tweenController = null;
        objectCreator = null;
    }

    public function to(target:Dynamic, duration:UInt, properties:Dynamic):TweenTarget {
        started = false;
        originalTargetProperties = {};
        this.target = target;
        startTime = getNow();
        this.duration = duration;
        originalProperties = properties;
        storeOriginalTargetValues();
        tweenTarget = objectCreator.createInstance(SimpleTweenTarget);
        tweenController.addTween(this);
        return tweenTarget;
    }

    public function update():Void {
        var now = getNow();
        var diff: Int = now - startTime;

        if(tweenTarget.delayValue > 0) {
            tweenTarget.delay(tweenTarget.delayValue - diff);
            startTime = now;
            if(tweenTarget.delayValue <= 0) {
                tweenTarget.delay(0);
            }
            return;
        }

        var percentComplete: Float = diff / duration;
        var delta: Float = tweenTarget.easeFunction(diff, 0, 1, duration);

        if(percentComplete >= 1) {
            updateFields(1);
            stop();
            if(tweenTarget.completeFunction != null) {
                tweenTarget.completeFunction(this);
            }
            return;
        }

        if(!started) {
            started = true;
            if(tweenTarget.beginFunction != null) {
                tweenTarget.beginFunction(this);
            }
        }

        updateFields(delta);

        if(tweenTarget.updateFunction != null) {
            tweenTarget.updateFunction(this);
        }
    }

    public inline function updateFields(percentComplete: Float):Void {
        var fields: Array<String> = Reflect.fields(originalProperties);
        for(field in fields) {
            var startPoint: Float = Reflect.getProperty(originalTargetProperties, field);
            var propValue: Float = startPoint + ((Reflect.getProperty(originalProperties, field) - startPoint) * percentComplete);
            Reflect.setProperty(target, field, propValue);
        }
    }

    public function storeOriginalTargetValues():Void {
        var fields: Array<String> = Reflect.fields(originalProperties);
        for(field in fields) {
            Reflect.setProperty(originalTargetProperties, field, Reflect.getProperty(target, field));
        }
    }

    public function stop():Void {
        tweenController.removeTween(this);
    }

    public function pause():Void {
        tweenController.removeTween(this);
    }

    public function resume():Void {
        tweenController.addTween(this);
    }

    public function reset():Void {
    }

    public #if !test inline #end function getNow(): UInt {
        return Timer.now();
    }
}
