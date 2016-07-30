package mocks;

import display.two.TwoDimDisplayNode;
import display.DisplayNodeContainer;
import display.BitmapNode;
class MockBitmapNode extends TwoDimDisplayNode implements BitmapNode {

//    @:isVar
//    public var parent(get, set):DisplayNodeContainer;

//    public function init():Void {
//    }
//
//    public function dispose():Void {
//    }

    @:isVar
    public var imageData(get, set):Dynamic;

    @:isVar
    public var sx(get, set):UInt;

    @:isVar
    public var sy(get, set):UInt;

    @:isVar
    public var sw(get, set):UInt;

//    @:isVar
//    public var depth(get, set):Float;
//
//    @:isVar
//    public var scaleX(get, set):Float;
//
//    @:isVar
//    public var scaleY(get, set):Float;
//
//    @:isVar
//    public var scaleZ(get, set):Float;

    @:isVar
    public var sh(get, set):UInt;

    public function new() {
        super();
    }

    public function get_imageData():Dynamic {
        return imageData;
    }

    public function set_imageData(value:Dynamic): Dynamic {
        return this.imageData = value;
    }

    public function set_sx(value:UInt) {
        return this.sx = value;
    }

    public function get_sx():UInt {
        return sx;
    }

    public function set_sy(value:UInt) {
        return this.sy = value;
    }

    public function get_sy():UInt {
        return sy;
    }

    public function set_sw(value:UInt) {
        return this.sw = value;
    }

    public function get_sw():UInt {
        return sw;
    }

    public function set_sh(value:UInt) {
        return this.sh = value;
    }

    public function get_sh():UInt {
        return sh;
    }

}