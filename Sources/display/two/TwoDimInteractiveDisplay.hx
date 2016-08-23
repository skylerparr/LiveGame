package display.two;
import input.PointerEventManager;
import input.PointerEvent;
import input.PointerEventType;
class TwoDimInteractiveDisplay extends TwoDimDisplayNode implements InteractiveDisplay {

    public static var pointerEventManager: PointerEventManager;

    public function new() {
        super();
    }

    override public function dispose():Void {
        super.dispose();
        if(pointerEventManager != null) {
            pointerEventManager.unregisterAll(this);
        }
    }

    public function registerPointerEvent(type:PointerEventType, handler:PointerEvent->Void):Void {
        pointerEventManager.registerEvent(this, type, handler);
    }

    public function unRegisterPointerEvent(type:PointerEventType, handler:PointerEvent->Void):Void {
        pointerEventManager.unregisterEvent(this, type, handler);
    }
}
