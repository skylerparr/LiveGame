package input;
import core.BaseObject;
import display.DisplayNode;
interface PointerEventManager extends BaseObject {
    function registerEvent(display: DisplayNode, type: PointerEventType, handler: PointerEvent->Void): Void;
    function unregisterEvent(display: DisplayNode, type: PointerEventType, handler: PointerEvent->Void): Void;
    function unregisterAll(display: DisplayNode): Void;
}
