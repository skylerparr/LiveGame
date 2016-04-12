package assets;
import core.BaseObject;
interface ImageAsset extends BaseObject {
    var width(get, null): UInt;
    var height(get, null): UInt;
    var imageData(get, null): Dynamic;

    function getPixel(x: UInt, y: UInt): UInt;
}
