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
    private var updateFunction: Void->Void;

    @Before
    public function setup():Void {
        tween = mock(Tween);
        subscriber = mock(MappedSubscriber);

        subscriber.subscribe(EventNames.ENTER_GAME_LOOP, cast isNotNull).calls(function(args: Array<Dynamic>): Void {
            updateFunction = args[1];
        });

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

    @Test
    public function shouldUpdateAllTweens(): Void {
        var tweens: Array<Tween> = generateTweens();
        updateFunction();
        for(t in tweens) {
            t.update().verify();
        }
    }

    @Test
    public function shouldPauseAllTweens(): Void {
        var tweens: Array<Tween> = generateTweens();
        controller.pauseAll();
        for(t in tweens) {
            t.pause().verify();
        }
    }

    @Test
    public function shouldResumeAllTweens(): Void {
        var tweens: Array<Tween> = generateTweens();
        controller.resumeAll();
        for(t in tweens) {
            t.resume().verify();
        }
    }

    @Test
    public function shouldStopAllTweens(): Void {
        var tweens: Array<Tween> = generateTweens();
        controller.stopAll();
        for(t in tweens) {
            t.stop().verify();
        }
    }

    private function generateTweens():Array<Tween> {
        var tweens: Array<Tween> = [];
        for(i in 0...10) {
            var t: Tween = mock(Tween);
            tweens.push(t);
        }
        for(t in tweens) {
            controller.addTween(t);
        }
        return tweens;
    }

}