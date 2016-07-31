package assets.kha;
@IgnoreCover
class KhaImageAsset implements ImageAsset {

    @:isVar
    public var width(get, null):UInt;

    @:isVar
    public var height(get, null):UInt;

    @:isVar
    public var data(get, set):Dynamic;

    public function get_data():Dynamic {
        return data;
    }

    public function set_data(value:Dynamic) {
        #if !test
        width = cast(value, kha.Image).realWidth;
        height = cast(value, kha.Image).realHeight;
        #end
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
