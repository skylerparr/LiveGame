package display;
import input.PointerEventType;
import input.PointerEvent;
interface InteractiveDisplay extends DisplayNode {
    function registerPointerEvent(type: PointerEventType, handler: PointerEvent->Void): Void;
    function unRegisterPointerEvent(type: PointerEventType, handler: PointerEvent->Void): Void;
}
