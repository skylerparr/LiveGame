package input;
import input.PointerEvent;
import core.ObjectCreator;
import display.DisplayNode;
class DisplayEventMouseInputHandlerDelegate implements DisplayEventMouseInputHandler {
    
    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var pointingInputSourceListener: PointingInputSourceListener;

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    public function mouseMove(nodes:List<DisplayNode>, mouseX:Int, mouseY:Int):Void {
    }

    public function mouseDown(nodes:List<DisplayNode>, button:Int, mouseX:Int, mouseY:Int):Void {
        var target: DisplayNode = findTarget(nodes);
        var pointerEvent: PointerEvent = createPointerEvent(target, mouseX, mouseY);
        pointingInputSourceListener.onPointerDown(pointerEvent);
    }

    public function mouseUp(nodes:List<DisplayNode>, button:Int, mouseX:Int, mouseY:Int):Void {
    }

    public function mouseWheel(nodes:List<DisplayNode>, delta:Int):Void {
    }

    private inline function createPointerEvent(target: DisplayNode, x: Int, y: Int): PointerEvent {
        var retVal: PointerEvent = objectCreator.createInstance(PointerEvent);
        retVal.target = target;
        retVal.screenX = x;
        retVal.screenY = y;
        return retVal;
    }

    private inline function findTarget(nodes:List<DisplayNode>):DisplayNode {
        var retVal: DisplayNode = null;
        for(node in nodes) {
            if(node.mouseEnabled) {
                retVal = node;
                break;
            }
        }
        return retVal;
    }
}
