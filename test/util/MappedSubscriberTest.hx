package util;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;


class MappedSubscriberTest {

    private var subscriber: MappedSubscriber;

    public function new() {

    }

    @Before
    public function setup():Void {
        subscriber = new MappedSubscriber();
        subscriber.init();
    }

    @After
    public function tearDown():Void {
        subscriber = null;
    }

    @Test
    public function shouldSubscribeToAnEvent(): Void {
        var func: Void->Void = function(): Void {}

        subscriber.subscribe("foo", func);

        Assert.areEqual(func, subscriber.subscriptions.get("foo")[0]);
    }

    @Test
    public function shouldSubscribeMultipleTimesToSameEvent(): Void {
        var func: Void->Void = function(): Void {}
        var func2: Void->Void = function(): Void {}
        var func3: Void->Void = function(): Void {}

        subscriber.subscribe("foo", func);
        subscriber.subscribe("foo", func2);
        subscriber.subscribe("foo", func3);

        Assert.areEqual(func, subscriber.subscriptions.get("foo")[0]);
        Assert.areEqual(func2, subscriber.subscriptions.get("foo")[1]);
        Assert.areEqual(func3, subscriber.subscriptions.get("foo")[2]);
    }

    @Test
    public function shouldUnsubscribeFromEvent(): Void {
        var func: Void->Void = function(): Void {}
        var func2: Void->Void = function(): Void {}
        var func3: Void->Void = function(): Void {}

        subscriber.subscribe("foo", func);
        subscriber.subscribe("foo", func2);
        subscriber.subscribe("foo", func3);

        subscriber.unsubscribe("foo", func2);

        Assert.areEqual(2, subscriber.subscriptions.get("foo").length);

        Assert.areEqual(func, subscriber.subscriptions.get("foo")[0]);
        Assert.areEqual(func3, subscriber.subscriptions.get("foo")[1]);
    }

    @Test
    public function shouldRemoveKeyIfNoHandlersExist(): Void {
        var func: Void->Void = function(): Void {}
        var func2: Void->Void = function(): Void {}
        var func3: Void->Void = function(): Void {}

        subscriber.subscribe("foo", func);
        subscriber.subscribe("foo", func2);
        subscriber.subscribe("foo", func3);

        subscriber.unsubscribe("foo", func);
        subscriber.unsubscribe("foo", func2);
        subscriber.unsubscribe("foo", func3);

        Assert.isFalse(subscriber.subscriptions.exists("foo"));
    }

    @Test
    public function shouldNotifyOnEvent(): Void {
        var func1Called: Bool = false;
        var func2Called: Bool = false;
        var func3Called: Bool = false;
        var func: Bool->Void = function(value: Bool): Void { func1Called = value; }
        var func2: Bool->Void = function(value: Bool): Void {func2Called = value; }
        var func3: Void->Void = function(): Void {func3Called = true; }

        subscriber.subscribe("foo", func);
        subscriber.subscribe("foo", func2);
        subscriber.subscribe("foo1", func3);

        subscriber.notify("foo", [true]);

        Assert.isTrue(func1Called);
        Assert.isTrue(func2Called);
        Assert.isFalse(func3Called);
    }
}