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

    private var cbCounter: Int;

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
        eventManager.registerEvent(display, PointerEventType.POINTER_MOVE, pointer1DownHandler);
        eventManager.registerEvent(display, PointerEventType.POINTER_1_CLICK, pointer1DownHandler);
        var subscriber: MappedSubscriber = eventManager.subscribers.get(display);

        eventManager.unregisterAll(display);
        objectCreator.disposeInstance(subscriber).verify();
        Assert.isNull(eventManager.subscribers.get(display));
    }

    @Test
    public function shouldTrimSubscriberMapWhenNoEventsLeft(): Void {
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        eventManager.registerEvent(display, PointerEventType.POINTER_1_DOWN, pointer1DownHandler);
        eventManager.registerEvent(display, PointerEventType.POINTER_1_UP, pointer1DownHandler);
        eventManager.registerEvent(display, PointerEventType.POINTER_MOVE, pointer1DownHandler);
        eventManager.registerEvent(display, PointerEventType.POINTER_1_CLICK, pointer1DownHandler);
        var subscriber: MappedSubscriber = eventManager.subscribers.get(display);

        eventManager.unregisterEvent(display, PointerEventType.POINTER_1_DOWN, pointer1DownHandler);
        eventManager.unregisterEvent(display, PointerEventType.POINTER_1_UP, pointer1DownHandler);
        eventManager.unregisterEvent(display, PointerEventType.POINTER_MOVE, pointer1DownHandler);
        eventManager.unregisterEvent(display, PointerEventType.POINTER_1_CLICK, pointer1DownHandler);

        Assert.isNull(eventManager.subscribers.get(display));
        objectCreator.disposeInstance(subscriber).verify();
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

    @Test
    public function shouldPassEventsToHandlersByDisplayNode(): Void {
        var cbCalled: Bool = false;
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        var pointerEvent: PointerEvent = createPointerEvent(display, 23, 34);
        eventManager.registerEvent(display, PointerEventType.POINTER_1_DOWN, function(pe: PointerEvent): Void {
            cbCalled = true;
            Assert.areEqual(pointerEvent, pe);
            Assert.areEqual(display, pe.target);
        });

        eventManager.onPointerDown(pointerEvent);
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldNotPassEventsToHandlerIfHandlerNotRegistered(): Void {
        var cbCalled: Bool = false;
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        var pointerEvent: PointerEvent = createPointerEvent(display, 23, 34);
        eventManager.registerEvent(display, PointerEventType.POINTER_2_DOWN, function(pe: PointerEvent): Void {
            cbCalled = true;
        });

        eventManager.onPointerDown(pointerEvent);
        Assert.isFalse(cbCalled);
    }

    @Test
    public function shouldNotPassEventsToHandlerIfDisplayNodeHasNoEvents(): Void {
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        var pointerEvent: PointerEvent = createPointerEvent(display, 23, 34);
        eventManager.onPointerDown(pointerEvent);
        Assert.isTrue(true);
    }

    @Test
    public function shouldPassOnAllEvents(): Void {
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        var pointerEvent: PointerEvent = createPointerEvent(display, 23, 34);
        assignEvents(display);
        eventManager.onPointerDown(pointerEvent);
        eventManager.onPointerUp(pointerEvent);
        eventManager.onPointerClick(pointerEvent);
        eventManager.onPointerMove(pointerEvent);
        eventManager.onPointerDoubleClick(pointerEvent);
        eventManager.onPointerRightDown(pointerEvent);
        eventManager.onPointerRightUp(pointerEvent);
        eventManager.onPointerRightClick(pointerEvent);
        eventManager.onPointerMiddleDown(pointerEvent);
        eventManager.onPointerMiddleUp(pointerEvent);
        eventManager.onPointerMiddleClick(pointerEvent);
        eventManager.onScroll(pointerEvent);
        Assert.areEqual(12, cbCounter);
    }

    @Test
    public function shouldNotPassOnAllEvents(): Void {
        var display: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        var pointerEvent: PointerEvent = createPointerEvent(display, 23, 34);
        eventManager.onPointerDown(pointerEvent);
        eventManager.onPointerUp(pointerEvent);
        eventManager.onPointerClick(pointerEvent);
        eventManager.onPointerMove(pointerEvent);
        eventManager.onPointerDoubleClick(pointerEvent);
        eventManager.onPointerRightDown(pointerEvent);
        eventManager.onPointerRightUp(pointerEvent);
        eventManager.onPointerRightClick(pointerEvent);
        eventManager.onPointerMiddleDown(pointerEvent);
        eventManager.onPointerMiddleUp(pointerEvent);
        eventManager.onPointerMiddleClick(pointerEvent);
        eventManager.onScroll(pointerEvent);
        Assert.areEqual(0, cbCounter);
    }

    private function assignEvents(display: DisplayNode):Void {
        eventManager.registerEvent(display, PointerEventType.POINTER_1_DOWN, function(pe: PointerEvent): Void {
            cbCounter++;
        });
        eventManager.registerEvent(display, PointerEventType.POINTER_1_UP, function(pe: PointerEvent): Void {
            cbCounter++;
        });
        eventManager.registerEvent(display, PointerEventType.POINTER_MOVE, function(pe: PointerEvent): Void {
            cbCounter++;
        });
        eventManager.registerEvent(display, PointerEventType.POINTER_1_CLICK, function(pe: PointerEvent): Void {
            cbCounter++;
        });
        eventManager.registerEvent(display, PointerEventType.POINTER_1_DOUBLE_CLICK, function(pe: PointerEvent): Void {
            cbCounter++;
        });
        eventManager.registerEvent(display, PointerEventType.POINTER_2_DOWN, function(pe: PointerEvent): Void {
            cbCounter++;
        });
        eventManager.registerEvent(display, PointerEventType.POINTER_2_UP, function(pe: PointerEvent): Void {
            cbCounter++;
        });
        eventManager.registerEvent(display, PointerEventType.POINTER_2_CLICK, function(pe: PointerEvent): Void {
            cbCounter++;
        });
        eventManager.registerEvent(display, PointerEventType.POINTER_3_DOWN, function(pe: PointerEvent): Void {
            cbCounter++;
        });
        eventManager.registerEvent(display, PointerEventType.POINTER_3_UP, function(pe: PointerEvent): Void {
            cbCounter++;
        });
        eventManager.registerEvent(display, PointerEventType.POINTER_3_CLICK, function(pe: PointerEvent): Void {
            cbCounter++;
        });
        eventManager.registerEvent(display, PointerEventType.ZOOM, function(pe: PointerEvent): Void {
            cbCounter++;
        });
    }

    private function pointer1DownHandler(event: PointerEvent):Void {

    }

    private function createPointerEvent(displayNode:DisplayNode, x:Int, y:Int):PointerEvent {
        var retVal: PointerEvent = new PointerEvent();
        retVal.target = displayNode;
        retVal.screenX = x;
        retVal.screenY = y;
        return retVal;
    }
}