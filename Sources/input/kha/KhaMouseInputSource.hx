package input.kha;
import core.ObjectCreator;
import core.BaseObject;
class KhaMouseInputSource implements BaseObject {

    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var gameInputTools: GameInputTools;

    public var pointerEvent: PointerEvent;
    private var leftMouseDown: Bool = false;

    private var mouseDownX: Int;
    private var mouseDownY: Int;

    public function new() {
    }

    public function init():Void {
        pointerEvent = objectCreator.createInstance(PointerEvent);
        initMouseNotifications();
    }

    public function dispose():Void {
        objectCreator.disposeInstance(pointerEvent);
        objectCreator = null;
        gameInputTools = null;
        pointerEvent = null;
    }

    public function onMouseDown(button: Int, x: Int, y: Int):Void {
        mouseDownX = x;
        mouseDownY = y;
        setPointerEvent(x, y);
        leftMouseDown = true;

        switch button {
            case 0: currentTool().onPointerDown(pointerEvent);
            case 1: currentTool().onPointerRightDown(pointerEvent);
        }
    }

    public function onMouseUp(button: Int, x: Int, y: Int):Void {
        setPointerEvent(x, y);
        switch button {
            case 0: currentTool().onPointerUp(pointerEvent);
            case 1: currentTool().onPointerRightUp(pointerEvent);
        }
        if(leftMouseDown) {
            currentTool().onPointerClick(pointerEvent);
            currentTool().onPointerRightClick(pointerEvent);
        }
        leftMouseDown = false;
    }

    public function onMouseMove(moveX: Int, moveY: Int, x: Int, y: Int):Void {
        setPointerEvent(x, y);
        currentTool().onPointerMove(pointerEvent);
        if(Math.abs(mouseDownX - x) > 3 || Math.abs(mouseDownY - y) > 3) {
            leftMouseDown = false;
        }
    }

    private inline function currentTool(): PointingTool {
        return gameInputTools.currentTool;
    }

    public function onMouseWheel(value: Int):Void {
        pointerEvent.mouseWheelValue = value;
        currentTool().onScroll(pointerEvent);
    }

    private function setPointerEvent(x:Int, y:Int):Void {
        pointerEvent.screenX = x;
        pointerEvent.screenY = y;
    }

    #if test
    public function initMouseNotifications():Void {

    }
    #else
    public function initMouseNotifications():Void {
        kha.input.Mouse.get().notify(onMouseDown, onMouseUp, onMouseMove, onMouseWheel);
    }
    #end
}
