package input;
import display.DisplayNodeContainer;
import input.PointerEvent;
import core.ObjectCreator;
import display.DisplayNode;
class DisplayEventMouseInputHandlerDelegate implements DisplayEventMouseInputHandler {
    
    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var pointingInputSourceListener: PointingInputSourceListener;

    public var pointerEvent: PointerEvent;
    public var currentTarget: DisplayNode;

    public function new() {
    }

    public function init():Void {
        pointerEvent = objectCreator.createInstance(PointerEvent);
    }

    public function dispose():Void {
        objectCreator.disposeInstance(pointerEvent);
        objectCreator = null;
        pointingInputSourceListener = null;
        pointerEvent = null;
        currentTarget = null;
    }

    public function mouseMove(nodes:List<DisplayNode>, mouseX:Int, mouseY:Int):Void {
        findTargetAndFireEvent(nodes, mouseX, mouseY, pointingInputSourceListener.onPointerMove);
    }

    public function mouseDown(nodes:List<DisplayNode>, button:Int, mouseX:Int, mouseY:Int):Void {
        switch button {
            case 0: findTargetAndFireEvent(nodes, mouseX, mouseY, pointingInputSourceListener.onPointerDown);
            case 1: findTargetAndFireEvent(nodes, mouseX, mouseY, pointingInputSourceListener.onPointerRightDown);
        }
    }

    private function findTargetAndFireEvent(nodes:List<DisplayNode>, mouseX: Int, mouseY: Int, event: PointerEvent->Void):Void {
        var target: DisplayNode = findTarget(nodes);
        if(target == null) {
            return;
        }
        currentTarget = target;
        setPointerEvent(target, mouseX, mouseY);
        event(pointerEvent);
    }

    public function mouseUp(nodes:List<DisplayNode>, button:Int, mouseX:Int, mouseY:Int):Void {
        var prevTarget: DisplayNode = currentTarget;
        switch button {
            case 0: findTargetAndFireEvent(nodes, mouseX, mouseY, pointingInputSourceListener.onPointerUp);
            case 1: findTargetAndFireEvent(nodes, mouseX, mouseY, pointingInputSourceListener.onPointerRightUp);
        }
        if(prevTarget != null && prevTarget == currentTarget) {
            switch button {
                case 0: findTargetAndFireEvent(nodes, mouseX, mouseY, pointingInputSourceListener.onPointerClick);
                case 1: findTargetAndFireEvent(nodes, mouseX, mouseY, pointingInputSourceListener.onPointerRightClick);
            }
        }
        currentTarget = null;
    }

    public function mouseWheel(nodes:List<DisplayNode>, delta:Int):Void {
        pointerEvent.target = findTarget(nodes);
        pointerEvent.mouseWheelValue = delta;
        pointingInputSourceListener.onScroll(pointerEvent);
    }

    private inline function setPointerEvent(target: DisplayNode, x: Int, y: Int): Void {
        pointerEvent.target = target;
        pointerEvent.screenX = x;
        pointerEvent.screenY = y;
    }

    private inline function findTarget(nodes:List<DisplayNode>):DisplayNode {
        var retVal: DisplayNode = null;
        for(node in nodes) {
            if(node.mouseEnabled) {
                if(Std.is(node, DisplayNodeContainer) && !cast(node, DisplayNodeContainer).mouseChildren) {
                    retVal = node;
                    break;
                } else if(!Std.is(node, DisplayNodeContainer)){
                    retVal = node;
                    break;
                }
            }
        }
        return retVal;
    }
}
