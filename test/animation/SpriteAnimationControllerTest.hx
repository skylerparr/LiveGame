package animation;

import util.MappedSubscriber;
import core.ObjectCreator;
import constants.EventNames;
import util.Subscriber;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class SpriteAnimationControllerTest {

    private var controller: SpriteAnimationController;
    private var animation: Animation;
    private var animationManager: AnimationManager;
    private var objectCreator: ObjectCreator;
    private var animationSubscriber: MappedSubscriber;

    public function new() {

    }

    @Before
    public function setup():Void {
        objectCreator = mock(ObjectCreator);
        animationManager = mock(AnimationManager);
        animation = mock(Animation);
        animationSubscriber = new MappedSubscriber();
        animationSubscriber.init();

        objectCreator.createInstance(MappedSubscriber).returns(animationSubscriber);

        controller = new SpriteAnimationController(animation);
        controller.animationManager = animationManager;
        controller.objectCreator = objectCreator;
        controller.init();
    }

    @After
    public function tearDown():Void {
        animation = null;
        controller = null;
    }

    @Test
    public function shouldStartTheAnimation(): Void {
        controller.start();
        animationManager.queueAnimationUpdate(controller).verify();
    }

    @Test
    public function shouldStopTheAnimation(): Void {
        controller.start();
        controller.stop();
        animationManager.dequeueAnimationUpdate(controller).verify();
    }

    @Test
    public function shouldNotBeAbleToStartTheAnimationAgainWithStoppingFirst(): Void {
        controller.start();
        controller.start();
        animationManager.queueAnimationUpdate(controller).verify(1);
    }

    @Test
    public function shouldNotBeAbleToStopUnlessHasBeenStarted(): Void {
        controller.stop();
        controller.start();
        controller.stop();
        controller.stop();
        animationManager.dequeueAnimationUpdate(controller).verify(1);
    }

    @Test
    public function shouldSetAnimationToFirstFrameOnStart(): Void {
        controller.start();
        animation.setFrame(0).verify();
    }

    @Test
    public function shouldPauseTheAnimation(): Void {
        controller.start();
        controller.pause();

        animationManager.dequeueAnimationUpdate(controller).verify();
    }

    @Test
    public function shouldNotPauseTheAnimationIfItWasNotStarted(): Void {
        controller.pause();
        animationManager.dequeueAnimationUpdate(controller).verify(0);
    }
    
    @Test
    public function shouldNotPauseIfAlreadyPaused(): Void {
        controller.start();
        controller.pause();
        controller.pause();

        animationManager.dequeueAnimationUpdate(controller).verify(1);
    }

    @Test
    public function shouldResumeAnimation(): Void {
        controller.start();
        controller.pause();
        controller.resume();

        animationManager.queueAnimationUpdate(controller).verify(2);
    }

    @Test
    public function shouldNotResumeAnimationUnlessPaused(): Void {
        controller.start();
        controller.resume();

        animationManager.queueAnimationUpdate(controller).verify(1);
    }

    @Test
    public function shouldCallStartHandlerWhenAnimationStarts(): Void {
        var called: Int = 0;
        controller.startHandler(function(): Void {
            called++;
        });

        controller.start();

        Assert.areEqual(1, called);
    }

    @Test
    public function shouldCallStopHandlerWhenAnimationStops(): Void {
        var called: Int = 0;
        controller.stopHandler(function(): Void {
            called++;
        });

        controller.start();
        controller.stop();

        Assert.areEqual(1, called);
    }

    @Test
    public function shouldNotCallStartHandlerIfHandlerWasRemoved(): Void {
        var called: Int = 0;
        var handler: Void ->Void = function(): Void {
            called++;
        }
        controller.startHandler(handler);

        controller.start();
        controller.stop();

        controller.removeStartHandler(handler);
        controller.start();

        Assert.areEqual(1, called);
    }

    @Test
    public function shouldNotCallStopHandlerIfHandlerWasRemoved(): Void {
        var called: Int = 0;
        var handler: Void ->Void = function(): Void {
            called++;
        }
        controller.stopHandler(handler);

        controller.start();
        controller.stop();

        controller.removeStopHandler(handler);
        controller.start();
        controller.stop();

        Assert.areEqual(1, called);
    }


}