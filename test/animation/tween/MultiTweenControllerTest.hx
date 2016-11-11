package animation.tween;

import util.MappedSubscriber;
import util.Subscriber;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;
class MultiTweenControllerTest {

    private var controller: MultiTweenController;
    private var subscriber: Subscriber;

    @Before
    public function setup():Void {
        subscriber = new MappedSubscriber();
        subscriber.init();

        controller = new MultiTweenController();
        controller.subscriber = subscriber;
        controller.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldPass(): Void {
        Assert.isTrue(true);
    }
}