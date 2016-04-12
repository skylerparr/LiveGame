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

    @:isVar
    public var imageData(get, set):Dynamic;

    function get_width():UInt {
        return width;
    }

    function set_width(value:UInt) {
        return this.width = value;
    }

    function set_height(value:UInt) {
        return this.height = value;
    }

    function get_height():UInt {
        return height;
    }

    function get_imageData():Dynamic {
        return imageData;
    }

    function set_imageData(value:Dynamic) {
        return this.imageData = value;
    }

    public function new() {
    }

    public function getPixel(x:UInt, y:UInt):UInt {
        return 0;
    }
}