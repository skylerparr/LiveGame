package display.two.kha;

interface MockKha2DGraphics {
    var fontSize(get, set): UInt;
    var color(get, set): MockKhaColor;
    var font(get, set): MockKhaFont;
    function drawSubImage(image: Dynamic, x: Float, y: Float, sx: Float, sy: Float, sw: Float, sh: Float): Void;
    function drawString(text: String, x: Float, y: Float): Void;
}