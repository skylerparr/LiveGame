package display.two.kha;
class KhaTextFieldNode extends TwoDimDisplayNode implements TextFieldNode {
    public var text(get, set):String;

    public var fontSize(get, set):UInt;

    public var fontColor(get, set):UInt;

    public var fontName(get, set):String;

    public function new() {
    }

    function set_text(value:String): String {
        return this.text = value;
    }

    function get_text():String {
        return text;
    }

    function get_fontSize():UInt {
        return fontSize;
    }

    function set_fontSize(value:UInt): UInt {
        return this.fontSize = value;
    }

    function get_fontColor():UInt {
        return fontColor;
    }

    function set_fontColor(value:UInt): UInt {
        return this.fontColor = value;
    }

    function get_fontName():String {
        return fontName;
    }

    function set_fontName(value:String):String {
        return this.fontName = value;
    }

}
