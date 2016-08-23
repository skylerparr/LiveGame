package display.two;

import input.PointerEvent;
import input.PointerEventType;
import input.PointerEventManager;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class TwoDimInteractiveDisplayTest {

    private var interactiveDisplay: TwoDimInteractiveDisplay;
    private var eventManager: PointerEventManager;

    @Before
    public function setup():Void {
        eventManager = mock(PointerEventManager);
        TwoDimInteractiveDisplay.pointerEventManager = eventManager;

        interactiveDisplay = new TwoDimInteractiveDisplay();
        interactiveDisplay.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldRegisterEventsOnEventManager(): Void {
        interactiveDisplay.registerPointerEvent(PointerEventType.POINTER_1_DOWN, pointer1Down);
        eventManager.registerEvent(interactiveDisplay, PointerEventType.POINTER_1_DOWN, pointer1Down).verify();
    }

    @Test
    public function shouldUnregisterEventsOnEventManager(): Void {
        interactiveDisplay.registerPointerEvent(PointerEventType.POINTER_1_DOWN, pointer1Down);
        interactiveDisplay.unRegisterPointerEvent(PointerEventType.POINTER_1_DOWN, pointer1Down);
        eventManager.unregisterEvent(interactiveDisplay, PointerEventType.POINTER_1_DOWN, pointer1Down).verify();
    }

    @Test
    public function shouldRemoveAllEventsOnDispose(): Void {
        interactiveDisplay.dispose();
        eventManager.unregisterAll(interactiveDisplay).verify();
    }

    private function pointer1Down(e:PointerEvent):Void {

    }
}