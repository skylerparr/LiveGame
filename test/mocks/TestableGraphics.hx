package mocks;

class TestableGraphics implements MockKha2DGraphics {

    @:isVar
    public var fontSize(get, set):UInt;

    @:isVar
    public var color(get, set):MockKhaColor;

    @:isVar
    public var font(get, set):MockKhaFont;

    public function new() {
    }

    public function get_fontSize():UInt {
        return fontSize;
    }

    public function set_fontSize(value:UInt) {
        return this.fontSize = value;
    }

    public function set_color(value:MockKhaColor) {
        return this.color = value;
    }

    public function get_color():MockKhaColor {
        return color;
    }

    public function get_font():MockKhaFont {
        return font;
    }

    public function set_font(value:MockKhaFont) {
        return this.font = value;
    }

    public function drawSubImage(image:Dynamic, x:Float, y:Float, sx:Float, sy:Float, sw:Float, sh:Float):Void {
    }

    public function drawString(text:String, x:Float, y:Float):Void {
    }
}

