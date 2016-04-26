package mocks;

import assets.ImageAsset;
class MockImageAsset implements ImageAsset {

    public function init():Void {
    }

    public function dispose():Void {
    }

    @:isVar
    public var width(get, set):UInt;

    @:isVar
    public var height(get, set):UInt;

    public function get_width():UInt {
        return width;
    }

    public function set_width(value:UInt) {
        return this.width = value;
    }

    public function set_height(value:UInt) {
        return this.height = value;
    }

    public function get_height():UInt {
        return height;
    }

    @:isVar
    public var data(get, set):Dynamic;

    public function get_data():Dynamic {
        return data;
    }

    public function set_data(value:Dynamic) {
        return this.data = value;
    }


    public function new() {
    }

    public function getPixel(x:UInt, y:UInt):UInt {
        return 0;
    }
}