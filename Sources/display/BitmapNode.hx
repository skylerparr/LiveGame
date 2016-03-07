package display;
interface BitmapNode extends DisplayNode {
    var imageData(get, set): Dynamic;

    var sx(get, set): UInt;
    var sy(get, set): UInt;
    var sw(get, set): UInt;
    var sh(get, set): UInt;
}
