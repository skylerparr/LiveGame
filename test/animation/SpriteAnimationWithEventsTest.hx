package animation;

import mocks.MockBitmapNode;
import util.MappedSubscriber;
import core.ObjectCreator;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class SpriteAnimationWithEventsTest {

    private var animation: SpriteAnimationWithEvents;
    private var objectCreator: ObjectCreator;
    private var subscriber: MappedSubscriber;

    @Before
    public function setup():Void {
        objectCreator = mock(ObjectCreator);
        subscriber = new MappedSubscriber();
        subscriber.init();
        objectCreator.createInstance(MappedSubscriber).returns(subscriber);

        animation = new SpriteAnimationWithEvents();
        animation.objectCreator = objectCreator;
        animation.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldSubscribeToOnComplete(): Void {
        var cbCalled: Bool = false;
        animation.subscribeOnComplete(function(a: AnimationWithEvents): Void {
            cbCalled = true;
        });
        subscriber.notify(SpriteAnimationWithEvents.ON_ANIMATION_COMPLETE, [animation]);
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldUnsubscribeToOnComplete(): Void {
        var cbCount: Int = 0;
        var cb = function(a: AnimationWithEvents): Void {
            cbCount++;
        }
        animation.subscribeOnComplete(cb);
        subscriber.notify(SpriteAnimationWithEvents.ON_ANIMATION_COMPLETE, [animation]);
        animation.unsubscribeOnComplete(cb);
        subscriber.notify(SpriteAnimationWithEvents.ON_ANIMATION_COMPLETE, [animation]);
        Assert.areEqual(1, cbCount);
    }

    @Test
    public function shouldDispatchOnAnimationCompleteOnLastFrame(): Void {
        animation.frames = [mock(Frame), mock(Frame), mock(Frame)];
        animation.bitmap = mock(MockBitmapNode);
        var cbCalled: Bool = false;
        animation.subscribeOnComplete(function(a: AnimationWithEvents): Void {
            cbCalled = true;
        });
        animation.nextFrame();
        Assert.isFalse(cbCalled);
        animation.nextFrame();
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldDispose(): Void {
        animation.dispose();
        objectCreator.disposeInstance(subscriber).verify();
        Assert.isNull(animation.objectCreator);
        Assert.isNull(animation.mappedSubscriber);
    }
}