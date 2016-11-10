package animation.tween.target;

import motion.easing.Linear;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class SimpleTweenTargetTest {


    private var simpleTweenTarget: SimpleTweenTarget;

    @Before
    public function setup():Void {
        simpleTweenTarget = new SimpleTweenTarget();
        simpleTweenTarget.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldAssignUpdateFunction(): Void {
        simpleTweenTarget.onUpdate(function(tween: Tween): Void {});
        Assert.isNotNull(simpleTweenTarget.updateFunction);
    }

    @Test
    public function shouldAssignBeginFunction(): Void {
        simpleTweenTarget.onBegin(function(tween: Tween): Void {});
        Assert.isNotNull(simpleTweenTarget.beginFunction);
    }

    @Test
    public function shouldAssignCompleteFunction(): Void {
        simpleTweenTarget.onComplete(function(tween: Tween): Void {});
        Assert.isNotNull(simpleTweenTarget.completeFunction);
    }

    @Test
    public function shouldAssignEaseFunction(): Void {
        simpleTweenTarget.ease(Linear.easeNone.ease);
        Assert.isNotNull(simpleTweenTarget.easeFunction);
    }

    @Test
    public function shouldAssignDelay(): Void {
        simpleTweenTarget.delay(400);
        Assert.areEqual(400, simpleTweenTarget.delayValue);
    }

    @Test
    public function shouldDispose(): Void {
        simpleTweenTarget.onUpdate(function(tween: Tween): Void {});
        simpleTweenTarget.onBegin(function(tween: Tween): Void {});
        simpleTweenTarget.onComplete(function(tween: Tween): Void {});
        simpleTweenTarget.ease(Linear.easeNone.ease);

        simpleTweenTarget.dispose();

        Assert.isNull(simpleTweenTarget.updateFunction);
        Assert.isNull(simpleTweenTarget.beginFunction);
        Assert.isNull(simpleTweenTarget.completeFunction);
        Assert.isNull(simpleTweenTarget.easeFunction);
    }
}