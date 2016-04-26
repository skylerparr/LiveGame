package assets.kha;
class KhaImageAsset implements ImageAsset {

    public var width(get, null):UInt;

    public var height(get, null):UInt;

    @:isVar
    public var data(get, set):Dynamic;

    public function get_data():Dynamic {
        return data;
    }

    public function set_data(value:Dynamic) {
        return this.data = value;
    }

    public function get_width():UInt {
        return width;
    }

    public function get_height():UInt {
        return height;
    }

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    public function getPixel(x:UInt, y:UInt):UInt {
        return 0;
    }
}
