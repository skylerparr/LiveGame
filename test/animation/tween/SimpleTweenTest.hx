package animation.tween;

import core.ObjectCreator;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;
class SimpleTweenTest {

    private var simpleTween: SimpleTween;
    private var objectCreator: ObjectCreator;
    private var tweenController: TweenController;
    private var tweenTarget: TweenTarget;

    @Before
    public function setup():Void {
        objectCreator = mock(ObjectCreator);
        tweenController = mock(TweenController);
        tweenTarget = mock(TweenTarget);

        simpleTween = new SimpleTween();
        simpleTween.objectCreator = objectCreator;
        simpleTween.tweenController = tweenController;
        simpleTween.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldPass(): Void {
        Assert.isTrue(true);
    }

}