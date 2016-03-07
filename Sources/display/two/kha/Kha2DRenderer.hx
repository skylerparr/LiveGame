package display.two.kha;
import kha.Font;
import kha.Color;
class Kha2DRenderer implements Renderer {
    
    @inject
    public var graphics: kha.graphics2.Graphics;

    private var container: KhaSprite;

    public static var fonts: Map<String, Font>;
    
    public function new(container: KhaSprite) {
        this.container = container;
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    public function render():Void {
        renderChildren(container, container.x, container.y);
    }

    private function renderChildren(container: KhaSprite, xPos: Float, yPos: Float) {
        for(child in container.children) {
            if(Std.is(child, KhaSprite)) {
                renderChildren(child, child.x + xPos, child.y + yPos);
            } else {
                if(Std.is(child, KhaBitmapNode)) {
                    var bitmap: KhaBitmapNode = cast(child, KhaBitmapNode);
                    graphics.drawSubImage(bitmap.imageData, bitmap.x, bitmap.y, bitmap.sx, bitmap.sy,
                        bitmap.sw, bitmap.sh);
                } else {
                    var textField: KhaTextFieldNode = cast(child, KhaTextFieldNode);
                    graphics.fontSize = textField.fontSize;
                    graphics.color = Color.fromValue(textField.fontColor);
                    graphics.font = fonts.get(textField.fontName);
                    graphics.drawString(textField.text, textField.y, textField.y);
//                    graphics.color = Color.White;
                }
            }
        }
    }
}
