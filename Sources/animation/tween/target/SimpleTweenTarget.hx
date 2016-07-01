package animation.tween.target;
import motion.easing.Linear;
class SimpleTweenTarget implements TweenTarget {
    @:isVar
    public var easeFunction(get, null):Float->Float->Float->Float->Float;

    @:isVar
    public var beginFunction(get, null): Tween->Void;

    @:isVar
    public var updateFunction(get, null): Tween->Void;

    @:isVar
    public var completeFunction(get, null): Tween->Void;

    @:isVar
    public var delayValue(get, null): UInt;

    function get_easeFunction():Float->Float->Float->Float->Float {
        return easeFunction;
    }

    function get_beginFunction(): Tween->Void {
        return beginFunction;
    }

    function get_updateFunction(): Tween->Void {
        return updateFunction;
    }

    function get_completeFunction(): Tween->Void {
        return completeFunction;
    }

    function get_delayValue(): UInt {
        return delayValue;
    }

    public function new() {
    }

    public function init():Void {
        easeFunction = Linear.easeNone.ease;
    }

    public function dispose():Void {
    }

    public function ease(easing:Float->Float->Float->Float->Float):TweenTarget {
        this.easeFunction = easing;
        return this;
    }

    public function delay(time:UInt):TweenTarget {
        this.delayValue = time;
        return this;
    }

    public function onBegin(func:Tween -> Void):TweenTarget {
        this.beginFunction = func;
        return this;
    }

    public function onUpdate(func:Tween -> Void):TweenTarget {
        this.updateFunction = func;
        return this;
    }

    public function onComplete(func:Tween -> Void):TweenTarget {
        this.completeFunction = func;
        return this;
    }

}
