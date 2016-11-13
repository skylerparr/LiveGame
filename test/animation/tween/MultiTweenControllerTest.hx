package animation.tween;

import constants.EventNames;
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
    private var tween: Tween;

    @Before
    public function setup():Void {
        tween = mock(Tween);
        subscriber = mock(MappedSubscriber);

        controller = new MultiTweenController();
        controller.subscriber = subscriber;
        controller.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldSubscribeToGameLoop(): Void {
        subscriber.subscribe(EventNames.ENTER_GAME_LOOP, cast isNotNull).verify();
    }

    @Test
    public function shouldDispose(): Void {
        controller.dispose();
        subscriber.unsubscribe(EventNames.ENTER_GAME_LOOP, cast isNotNull).verify();
        Assert.isNull(controller.subscriber);
        Assert.isNull(controller.allTweens);
    }

    @Test
    public function shouldAddTween(): Void {
        controller.addTween(tween);
        Assert.areEqual(tween, controller.allTweens.get(tween));
    }

    @Test
    public function shouldRemoveTween(): Void {
        controller.addTween(tween);
        controller.removeTween(tween);
        Assert.isNull(controller.allTweens.get(tween));
    }
}