package assets;
import core.BaseObject;
interface ImageAsset extends ResourceAsset {
    var width(get, null): UInt;
    var height(get, null): UInt;

    function getPixel(x: UInt, y: UInt): UInt;
}
