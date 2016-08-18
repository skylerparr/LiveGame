package display.two;
import input.PointerEventManager;
import input.PointerEvent;
import input.PointerEventType;
class TwoDimInteractiveDisplay extends TwoDimDisplayNode implements InteractiveDisplay {

    public static var pointerEventManager: PointerEventManager;

    public function new() {
        super();
    }

    public function registerPointerEvent(type:PointerEventType, handler:PointerEvent->Void):Void {
    }

    public function unRegisterPointerEvent(type:PointerEventType, handler:PointerEvent->Void):Void {
    }
}
