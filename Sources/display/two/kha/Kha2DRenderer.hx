package display.two.kha;

class Kha2DRenderer implements Renderer {

    #if test
    @inject
    public var graphics: MockKha2DGraphics;

    public static var fonts: Map<String, MockKhaFont>;
    #else
    @inject
    public var graphics: kha.graphics2.Graphics;

    public static var fonts: Map<String, kha.Font>;
    #end

    private var container: KhaSprite;


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
                renderChildren(cast(child, KhaSprite), child.x + xPos, child.y + yPos);
            } else {
                if(Std.is(child, KhaBitmapNode)) {
                    var bitmap: KhaBitmapNode = cast(child, KhaBitmapNode);
                    graphics.drawSubImage(bitmap.imageData, bitmap.x + xPos, bitmap.y + yPos, bitmap.sx, bitmap.sy,
                        bitmap.sw, bitmap.sh);
                } else {
                    var textField: KhaTextFieldNode = cast(child, KhaTextFieldNode);
                    graphics.fontSize = textField.fontSize;
                    graphics.color = getColorFromValue(textField.fontColor);
                    graphics.font = fonts.get(textField.fontName);
                    graphics.drawString(textField.text, textField.x + xPos, textField.y + yPos);
                    graphics.color = getWhite();
                }
            }
        }
    }

    #if test
    private inline function getColorFromValue(value: UInt): display.two.kha.Kha2DRendererTest.MockColor {
        return new MockColor();
    }

    private inline function getWhite():display.two.kha.Kha2DRendererTest.MockColor {
        return new MockColor();
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
