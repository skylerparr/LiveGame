package input.kha;

import geom.Rectangle;
import geom.Point;
import collections.QuadTree;
import util.MappedSubscriber;
import mocks.MockDisplayNodeContainer;
import display.DisplayNode;
import core.ObjectCreator;
import util.MappedSubscriber;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class KhaPointerEventManagerTest {

    private var eventManager: KhaPointerEventManager;
    private var objectCreator: ObjectCreator;

    @Before
    public function setup():Void {
        objectCreator = mock(ObjectCreator);
        objectCreator.createInstance(MappedSubscriber).calls(function(args): MappedSubscriber {
            var subscriber: MappedSubscriber = new MappedSubscriber();
            subscriber.init();
            return subscriber;
        });
        objectCreator.createInstance(QuadTree).calls(function(args): QuadTree {
            return new QuadTree(new Rectangle(0,0,800,600));
        });

        eventManager = new KhaPointerEventManager();
        eventManager.objectCreator = objectCreator;
        eventManager.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldRegisterEventOnDisplayNode(): Void {
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        eventManager.registerEvent(display, PointerEventType.POINTER_1_DOWN, pointer1DownHandler);
        Assert.isTrue(eventManager.subscribers.get(display).subscriptions.exists(PointerEventType.POINTER_1_DOWN + ""));
    }

    @Test
    public function shouldNotRegisterEventIfAnyArgumentIsNull(): Void {
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        eventManager.registerEvent(display, null, pointer1DownHandler);
        Assert.isFalse(eventManager.subscribers.exists(display));

        display = mock(MockDisplayNodeContainer);
        eventManager.registerEvent(display, PointerEventType.POINTER_1_DOWN, null);
        Assert.isFalse(eventManager.subscribers.exists(display));

        eventManager.registerEvent(null, PointerEventType.POINTER_1_DOWN, pointer1DownHandler);
        Assert.isFalse(eventManager.subscribers.exists(display));
    }

    @Test
    public function shouldUnRegisterEvent(): Void {
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        eventManager.registerEvent(display, PointerEventType.POINTER_1_DOWN, pointer1DownHandler);
        var subscriber: MappedSubscriber = eventManager.subscribers.get(display);
        eventManager.unregisterEvent(display, PointerEventType.POINTER_1_DOWN, pointer1DownHandler);

        Assert.isFalse(subscriber.subscriptions.exists(PointerEventType.POINTER_1_DOWN + ""));
    }

    @Test
    public function shouldNotCrashUnRegister(): Void {
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        eventManager.unregisterEvent(display, PointerEventType.POINTER_1_DOWN, pointer1DownHandler);

        eventManager.unregisterEvent(null, PointerEventType.POINTER_1_DOWN, pointer1DownHandler);
        eventManager.unregisterEvent(display, null, pointer1DownHandler);
        eventManager.unregisterEvent(display, PointerEventType.POINTER_1_DOWN, null);
        Assert.isTrue(true);
    }

    @Test
    public function shouldRemoveAllEventsFromDisplay(): Void {
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        eventManager.registerEvent(display, PointerEventType.POINTER_1_DOWN, pointer1DownHandler);
        eventManager.registerEvent(display, PointerEventType.POINTER_1_UP, pointer1DownHandler);
        eventManager.registerEvent(display, PointerEventType.POINTER_1_MOVE, pointer1DownHandler);
        eventManager.registerEvent(display, PointerEventType.POINTER_1_CLICK, pointer1DownHandler);
        var subscriber: MappedSubscriber = eventManager.subscribers.get(display);

        eventManager.unregisterAll(display);
        objectCreator.disposeInstance(subscriber).verify();
        Assert.isNull(eventManager.subscribers.get(display));
    }

    @Test
    public function shouldDispose(): Void {
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        eventManager.registerEvent(display, PointerEventType.POINTER_1_DOWN, pointer1DownHandler);

        eventManager.dispose();
        objectCreator.disposeInstance(cast instanceOf(MappedSubscriber)).verify();
        Assert.isNull(eventManager.objectCreator);
        Assert.isNull(eventManager.subscribers);
    }

    private function pointer1DownHandler(event: PointerEvent):Void {

    }
}