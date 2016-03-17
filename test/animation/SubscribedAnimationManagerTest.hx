package animation;

import util.Subscriber;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class SubscribedAnimationManagerTest {

    private var animationManager: TestableSubscribedAnimationManager;
    private var subscriber: Subscriber;

    public function new() {

    }

    @Before
    public function setup():Void {
        subscriber = mock(Subscriber);

        animationManager = new TestableSubscribedAnimationManager("myEvent");
        animationManager.subscriber = subscriber;
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldSubscribeToSubscriber(): Void {
        animationManager.init();
        subscriber.subscribe("myEvent", cast any).verify();
    }

    @Test
    public function shouldQueueAnimationToBeAnimated(): Void {
        animationManager.init();
        var animController: SpriteAnimationController = mock(SpriteAnimationController);
        animationManager.queueAnimationUpdate(animController);

        var counter = 0;
        for(i in animationManager.animations) {
            counter++;
        }
        Assert.areEqual(1, counter);
    }

    @Test
    public function shouldRemoveAnimationFromAnimationQueue(): Void {
        animationManager.init();
        var animController: SpriteAnimationController = mock(SpriteAnimationController);
        animationManager.queueAnimationUpdate(animController);
        animationManager.dequeueAnimationUpdate(animController);

        var counter = 0;
        for(i in animationManager.animations) {
            counter++;
        }
        Assert.areEqual(0, counter);
    }

    @Test
    public function shouldCallNextFrameOnAnimationWhenReady(): Void {
        var ourHandler: Void->Void = null;
        subscriber.subscribe("myEvent", cast any).calls(function(args: Array<Dynamic>): Void {
            ourHandler = args[1];
        });
        animationManager.init();

        var animation: Animation = mock(Animation);
        var animController: SpriteAnimationController = mock(SpriteAnimationController);
        animation.frameTime.returns(80);
        animController.animation.returns(animation);

        animationManager.queueAnimationUpdate(animController);

        animationManager.currentTime = 20;
        ourHandler();
        animation.nextFrame().verify(0);

        animationManager.currentTime = 30;
        ourHandler();
        animationManager.currentTime = 40;
        ourHandler();
        animationManager.currentTime = 50;
        ourHandler();
        animationManager.currentTime = 60;
        ourHandler();
        animationManager.currentTime = 70;
        ourHandler();
        animationManager.currentTime = 80;
        ourHandler();
        animationManager.currentTime = 90;
        ourHandler();
        animation.nextFrame().verify();
    }

}

