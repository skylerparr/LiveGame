package display.two.kha;
@IgnoreCover
class KhaTextFieldNode extends TwoDimInteractiveDisplay implements TextFieldNode {
    @:isVar
    public var text(get, set):String;

    @:isVar
    public var fontSize(get, set):UInt;

    @:isVar
    public var fontColor(get, set):UInt;

    @:isVar
    public var fontName(get, set):String;

    public function new() {
        super();
    }

    public function set_text(value:String): String {
        return this.text = value;
    }

    public function get_text():String {
        return text + "";
    }

    public function get_fontSize():UInt {
        return fontSize;
    }

    public function set_fontSize(value:UInt): UInt {
        return this.fontSize = value;
    }

    public function get_fontColor():UInt {
        return fontColor;
    }

    public function set_fontColor(value:UInt): UInt {
        return this.fontColor = value;
    }

    public function get_fontName():String {
        return fontName;
    }

    public function set_fontName(value:String):String {
        return this.fontName = value;
    }

}
