package input;
import display.DisplayNode;
import core.BaseObject;
interface DisplayEventMouseInputHandler extends BaseObject {
    function mouseMove(nodes: List<DisplayNode>, mouseX: Int, mouseY: Int): Void;
    function mouseDown(nodes: List<DisplayNode>, button: Int, mouseX: Int, mouseY: Int): Void;
    function mouseUp(nodes: List<DisplayNode>, button: Int, mouseX: Int, mouseY: Int): Void;
    function mouseWheel(nodes: List<DisplayNode>, delta: Int): Void;
}