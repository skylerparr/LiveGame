package animation.tween.target;

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
}