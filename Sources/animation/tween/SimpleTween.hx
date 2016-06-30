package animation.tween;
import animation.tween.target.SimpleTweenTarget;
import util.Timer;
import core.ObjectCreator;
class SimpleTween implements Tween {

    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var tweenController: TweenController;

    private var currentTime: UInt;
    private var totalTime: UInt;

    private var originalProperties: Dynamic;

    private var tweenTarget: TweenTarget;
    private var started: Bool;
    private var target: Dynamic;

    public function new() {
    }

    public function init():Void {
        started = false;
    }

    public function dispose():Void {

    }

    public function to(target:Dynamic, time:UInt, properties:Dynamic):TweenTarget {
        this.target = target;
        currentTime = Timer.now();
        totalTime = time;
        originalProperties = properties;
        tweenTarget = objectCreator.createInstance(SimpleTweenTarget);
        tweenController.addTween(this);
        return target;
    }

    public function update():Void {
        var now = Timer.now();
        var percentComplete: Float = (now - currentTime) / totalTime;

        if(percentComplete > 1) {
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

        updateFields(percentComplete);

        if(tweenTarget.updateFunction != null) {
            tweenTarget.updateFunction(this);
        }
    }

    private function updateFields(percentComplete: Float):Void {
        var fields: Array<String> = Reflect.fields(originalProperties);
        for(field in fields) {
            Reflect.setProperty(target, field, Reflect.getProperty(originalProperties, field) * percentComplete);
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

}
