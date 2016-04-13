package mocks;

import display.DisplayNodeContainer;
import display.BitmapNode;
class MockBitmapNode implements BitmapNode {

    @:isVar
    public var parent(get, set):DisplayNodeContainer;

    public function init():Void {
    }

    public function dispose():Void {
    }

    @:isVar
    public var imageData(get, set):Dynamic;

    @:isVar
    public var sx(get, set):UInt;

    @:isVar
    public var sy(get, set):UInt;

    @:isVar
    public var sw(get, set):UInt;

    @:isVar
    public var depth(get, set):Float;

    @:isVar
    public var scaleX(get, set):Float;

    @:isVar
    public var scaleY(get, set):Float;

    @:isVar
    public var scaleZ(get, set):Float;

    @:isVar
    public var sh(get, set):UInt;

    @:isVar
    public var x(get, set):Float;

    @:isVar
    public var y(get, set):Float;

    @:isVar
    public var z(get, set):Float;

    @:isVar
    public var width(get, set):Float;

    @:isVar
    public var height(get, set):Float;

    @:isVar
    public var name(get, set):String;

    public function new() {
    }

    public function set_parent(value:DisplayNodeContainer) {
        return this.parent = value;
    }

    public function get_parent():DisplayNodeContainer {
        return parent;
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

    public function set_depth(value:Float) {
        return this.depth = value;
    }

    public function get_depth():Float {
        return depth;
    }

    public function get_scaleX():Float {
        return scaleX;
    }

    public function set_scaleX(value:Float) {
        return this.scaleX = value;
    }

    public function set_scaleY(value:Float) {
        return this.scaleY = value;
    }

    public function get_scaleY():Float {
        return scaleY;
    }

    public function set_scaleZ(value:Float) {
        return this.scaleZ = value;
    }

    public function get_scaleZ():Float {
        return scaleZ;
    }

    public function set_sh(value:UInt) {
        return this.sh = value;
    }

    public function get_sh():UInt {
        return sh;
    }

    public function get_x():Float {
        return x;
    }

    public function set_x(value:Float) {
        return this.x = value;
    }

    public function set_y(value:Float) {
        return this.y = value;
    }

    public function get_y():Float {
        return y;
    }

    public function set_z(value:Float) {
        return this.z = value;
    }

    public function get_z():Float {
        return z;
    }

    public function get_width():Float {
        return width;
    }

    public function set_width(value:Float) {
        return this.width = value;
    }

    public function set_height(value:Float) {
        return this.height = value;
    }

    public function get_height():Float {
        return height;
    }

    public function set_name(value:String) {
        return this.name = value;
    }

    public function get_name():String {
        return name;
    }
}