package display;
interface TextFieldNode extends InteractiveDisplay {
    var text(get, set): String;
    var fontSize(get, set): UInt;
    var fontColor(get, set): UInt;
    var fontName(get, set): String;
}
