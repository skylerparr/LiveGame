package display.two.kha;

import input.DisplayEventMouseInputHandler;
import geom.Point;
class Kha2DRenderer implements Renderer {

    #if test
    @inject
    public var graphics: mocks.MockKha2DGraphics;

    public static var fonts: Map<String, mocks.MockKhaFont>;
    #else
    @inject
    public var graphics: kha.graphics2.Graphics;

    public static var fonts: Map<String, kha.Font>;
    #end

    @inject
    public var inputHandler: DisplayEventMouseInputHandler;

    public var container: KhaSprite;

    private var nodesUnderPoint: List<DisplayNode>;

    private var currentMouseX: Int;
    private var currentMouseY: Int;

    private var isDirty: Bool = false;

    public function new() {
    }

    public function init():Void {
        nodesUnderPoint = new List();
        #if !test
        kha.input.Mouse.get(0).notify(null, onUp, onMove, null);
        #end
    }

    public function dispose():Void {
        container = null;
        graphics = null;
    }

    private function onMove(x:Int, y:Int, diffX: Int, diffY: Int):Void {
        currentMouseX = x;
        currentMouseY = y;
        nodesUnderPoint.clear();
        isDirty = true;
        trace("mouse moved");
    }

    private function onUp(but:Int, x:Int, y:Int):Void {
        trace("items under mouse");
        for(node in nodesUnderPoint) {
            trace('${node.name} : ${node.x}, ${node.y}');
        }
    }

    public function render():Void {
        renderChildren(container, container.x, container.y);
        if(isDirty) {
            inputHandler.mouseMove(nodesUnderPoint, currentMouseX, currentMouseY);
            isDirty = false;
        }
    }

    private inline function renderChildren(container: KhaSprite, xPos: Float, yPos: Float): Void {
        var children = container.children;
        for(child in children) {
            if(Std.is(child, KhaSprite)) {
                var x: Float = child.x + xPos;
                var y: Float = child.y + yPos;
                renderChildren(cast child, x, y);
                if(isUnderMouse(x, y, child.width, child.height)) {
                    storeItemUnderMouse(child);
                }
            } else {
                if(Std.is(child, KhaBitmapNode)) {
                    var bitmap: KhaBitmapNode = cast child;
                    if(bitmap.imageData != null) {
                        var x: Float = bitmap.x + xPos;
                        var y: Float = bitmap.y + yPos;
                        graphics.drawSubImage(bitmap.imageData, x, y, bitmap.sx, bitmap.sy,
                        bitmap.sw, bitmap.sh);
                        if(isUnderMouse(x, y, bitmap.width, bitmap.height)) {
                            storeItemUnderMouse(bitmap);
                        }
                    }
                } else {
                    var textField: KhaTextFieldNode = cast child;
                    graphics.fontSize = textField.fontSize;
                    graphics.color = getColorFromValue(textField.fontColor);
                    graphics.font = fonts.get(textField.fontName);
                    graphics.drawString(textField.text, textField.x + xPos, textField.y + yPos);
                    graphics.color = getWhite();
                }
            }
        }
    }

    private inline function storeItemUnderMouse(displayNode: DisplayNode): Void {
        nodesUnderPoint.add(displayNode);
    }

    private inline function isUnderMouse(x: Float, y: Float, width: Float, height: Float): Bool {
        return (isDirty && currentMouseX >= x &&
            currentMouseX <= x + width &&
            currentMouseY >= y &&
            currentMouseY <= y + height);
    }

    #if test
    private inline function getColorFromValue(value: UInt): mocks.MockColor {
        return new mocks.MockColor();
    }

    private inline function getWhite():mocks.MockColor {
        return new mocks.MockColor();
    }
    #else
    private inline function getColorFromValue(value: UInt): kha.Color {
        return kha.Color.fromValue(value);
    }
    private inline function getWhite(): kha.Color {
        return kha.Color.White;
    }
    #end
}
