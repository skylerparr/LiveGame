package animation.tween;

import motion.easing.Linear;
import animation.tween.target.SimpleTweenTarget;
import animation.tween.TweenTarget;
import core.ObjectCreator;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;
class SimpleTweenTest {

    private var simpleTween: TestableSimpleTween;
    private var objectCreator: ObjectCreator;
    private var tweenController: TweenController;
    private var tweenTarget: SimpleTweenTarget;

    @Before
    public function setup():Void {
        objectCreator = mock(ObjectCreator);
        tweenController = mock(TweenController);
        tweenTarget = mock(SimpleTweenTarget);

        objectCreator.createInstance(SimpleTweenTarget).returns(tweenTarget);
        tweenTarget.get_easeFunction().returns(Linear.easeNone.ease);

        simpleTween = new TestableSimpleTween();
        simpleTween.objectCreator = objectCreator;
        simpleTween.tweenController = tweenController;
        simpleTween.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldGetTweenTargetOnTo(): Void {
        var objectToTween: Dynamic = {x: 10};
        var target: TweenTarget = simpleTween.to(objectToTween, 1000, {x: 100});

        Assert.areEqual(tweenTarget, target);
        Assert.isFalse(simpleTween.started);
        Assert.areEqual(10, simpleTween.originalTargetProperties.x);
        Assert.areEqual(objectToTween, simpleTween.target);
        Assert.areEqual(0, simpleTween.startTime);
        Assert.areEqual(1000, simpleTween.duration);
        Assert.areEqual(100, simpleTween.originalProperties.x);
        tweenController.addTween(simpleTween).verify();
    }

    @Test
    public function shouldSetStartedToTrueOnFirstUpdate(): Void {
        var objectToTween: Dynamic = {x: 10};
        var target: TweenTarget = simpleTween.to(objectToTween, 1000, {x: 100});

        simpleTween.update();

        Assert.isTrue(simpleTween.started);
    }

    @Test
    public function shouldUpdateFields(): Void {
        var objectToTween: Dynamic = {x: 10};
        simpleTween.time = 0;
        var target: TweenTarget = simpleTween.to(objectToTween, 1000, {x: 100});

        simpleTween.time = 100;
        simpleTween.update();

        Assert.isTrue(10 < objectToTween.x);
        Assert.areEqual(19, objectToTween.x);
    }

    @Test
    public function shouldKeepUpdatingUntilComplete(): Void {
        var objectToTween: Dynamic = {x: 10};
        simpleTween.time = 0;
        var target: TweenTarget = simpleTween.to(objectToTween, 1000, {x: 100});

        simpleTween.time = 100;
        simpleTween.update();

        simpleTween.time = 1200;
        simpleTween.update();

        Assert.areEqual(100, objectToTween.x);
        tweenController.removeTween(simpleTween);
    }

    @Test
    public function shouldCallDelayOnTweenTargetAndUpdateStartTime(): Void {
        var objectToTween: Dynamic = {x: 10};
        simpleTween.time = 0;
        var target: TweenTarget = simpleTween.to(objectToTween, 1000, {x: 100});
        tweenTarget.get_delayValue().returns(120);

        for(i in 0...12) {
            simpleTween.time = Std.int(100 / i);
            simpleTween.update();
            Assert.areEqual(10, objectToTween.x);
        }

        Assert.areEqual(0, simpleTween.startTime);
        tweenTarget.delay(20).verify();

        Mockatoo.reset(tweenTarget);
        tweenTarget.get_easeFunction().returns(Linear.easeNone.ease);
        tweenTarget.get_delayValue().returns(0);
        simpleTween.time = 300;
        simpleTween.update();

        Assert.isTrue(10 < objectToTween.x);
    }

    @Test
    public function shouldCallBeginFunctionIfDefined(): Void {
        var objectToTween: Dynamic = {x: 10};
        simpleTween.time = 0;
        var target: TweenTarget = simpleTween.to(objectToTween, 1000, {x: 100});
        var cbCalled: Bool = false;
        tweenTarget.get_beginFunction().returns(function(tween: SimpleTween): Void {
            cbCalled = true;
            Assert.areEqual(simpleTween, tween);
        });
        simpleTween.update();

        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldCallCompeteFunctionIfDefined(): Void {
        var objectToTween: Dynamic = {x: 10};
        simpleTween.time = 0;
        var target: TweenTarget = simpleTween.to(objectToTween, 1000, {x: 100});
        var cbCalled: Bool = false;
        tweenTarget.get_completeFunction().returns(function(tween: SimpleTween): Void {
            cbCalled = true;
            Assert.areEqual(simpleTween, tween);
        });
        simpleTween.time = 1000;
        simpleTween.update();

        Assert.isTrue(cbCalled);
        Assert.areEqual(100, objectToTween.x);
    }

    @Test
    public function shouldCallBeginFunctionOnlyOnce(): Void {
        var objectToTween: Dynamic = {x: 10};
        simpleTween.time = 0;
        var target: TweenTarget = simpleTween.to(objectToTween, 1000, {x: 100});
        tweenTarget.get_beginFunction().returns(function(tween: SimpleTween): Void {
        });
        simpleTween.update();
        simpleTween.update();
        simpleTween.update();
        simpleTween.update();

        tweenTarget.get_beginFunction().verify(2);
    }

    @Test
    public function shouldCalledTheUpdateFunctionIfDefined(): Void {
        var objectToTween: Dynamic = {x: 10};
        simpleTween.time = 0;
        var target: TweenTarget = simpleTween.to(objectToTween, 1000, {x: 100});
        var cbCalled: Bool = false;
        tweenTarget.get_updateFunction().returns(function(tween: SimpleTween): Void {
            cbCalled = true;
            Assert.areEqual(simpleTween, tween);
        });
        simpleTween.update();
        simpleTween.update();
        simpleTween.update();
        simpleTween.update();

        Assert.isTrue(cbCalled);

        tweenTarget.get_updateFunction().verify(8);
    }

    @Test
    public function shouldPauseTween(): Void {
        var objectToTween: Dynamic = {x: 10};
        simpleTween.time = 0;
        var target: TweenTarget = simpleTween.to(objectToTween, 1000, {x: 100});
        simpleTween.update();

        simpleTween.pause();

        tweenController.removeTween(simpleTween).verify();
    }

    @Test
    public function shouldStopTween(): Void {
        var objectToTween: Dynamic = {x: 10};
        simpleTween.time = 0;
        var target: TweenTarget = simpleTween.to(objectToTween, 1000, {x: 100});
        simpleTween.update();

        simpleTween.stop();

        tweenController.removeTween(simpleTween).verify();
    }

    @Test
    public function shouldResumeTween(): Void {
        var objectToTween: Dynamic = {x: 10};
        simpleTween.time = 0;
        var target: TweenTarget = simpleTween.to(objectToTween, 1000, {x: 100});
        simpleTween.update();

        simpleTween.resume();

        tweenController.addTween(simpleTween).verify(2);
    }

    @Test
    public function resetDoesNothing(): Void {
        simpleTween.reset();
        Assert.isTrue(true);
    }

    @Test
    public function shouldDispose(): Void {
        var objectToTween: Dynamic = {x: 10};
        simpleTween.time = 0;
        var target: TweenTarget = simpleTween.to(objectToTween, 1000, {x: 100});
        simpleTween.update();

        simpleTween.dispose();

        tweenController.removeTween(simpleTween).verify();
        objectCreator.disposeInstance(target);
        Assert.isNull(simpleTween.tweenTarget);
        Assert.isFalse(simpleTween.started);
        Assert.isNull(simpleTween.originalProperties);
        Assert.isNull(simpleTween.target);
        Assert.isNull(simpleTween.originalTargetProperties);
        Assert.isNull(simpleTween.tweenController);
        Assert.isNull(simpleTween.objectCreator);
    }

}

class TestableSimpleTween extends SimpleTween {
    public var time: UInt;

    override public function getNow():UInt {
        return time;
    }
}