package animation.tween;
import core.ObjectCreator;
import display.DisplayNode;
class TweenDelegate implements Tween {

    @inject
    public var objectCreator: ObjectCreator;

    private var actualTween: Tween;

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
        objectCreator.disposeInstance(actualTween);
        actualTween = null;
        objectCreator = null;
    }

    public function to(target:Dynamic, time:UInt, properties:Dynamic):TweenTarget {
        if(Std.is(target, DisplayNode)) {
            actualTween = objectCreator.createInstance(DisplayTween);
        } else {
            actualTween = objectCreator.createInstance(SimpleTween);
        }
        return actualTween.to(target, time, properties);
    }

    public function stop():Void {
        actualTween.stop();
    }

    public function pause():Void {
        actualTween.pause();
    }

    public function resume():Void {
        actualTween.resume();
    }

    public function reset():Void {
        actualTween.reset();
    }

    public function update():Void {
        actualTween.update();
    }

}
