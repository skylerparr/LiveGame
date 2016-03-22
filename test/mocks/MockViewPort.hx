package mocks;

import display.DisplayNode;
import world.ViewPort;
import geom.Rectangle;
class MockViewPort implements ViewPort {

    public function isInViewableRegion(value:DisplayNode):Bool {
        return false;
    }

    public function subscribeToTranslate(listener:Void->Void):Void {
    }

    public function unsubscribeToTranslate(listener:Void->Void):Void {
    }

    public function subscribeToResize(listener:Void->Void):Void {
    }

    public function unsubscribeToResize(listener:Void->Void):Void {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    @:isVar
    public var height(get, set):Float;

    @:isVar
    public var width(get, set):Float;

    @:isVar
    public var x(get, set):Float;

    @:isVar
    public var y(get, set):Float;

    @:isVar
    public var z(get, set):Float;

    @:isVar
    public var scale(get, set):Float;

    @:isVar
    public var dimension(get, set):Rectangle;

    public function new() {
    }

    public function set_height(value:Float) {
        return this.height = value;
    }

    public function get_height():Float {
        return height;
    }

    public function get_width():Float {
        return width;
    }

    public function set_width(value:Float) {
        return this.width = value;
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

    public function get_scale():Float {
        return scale;
    }

    public function set_scale(value:Float) {
        return this.scale = value;
    }

    public function get_dimension():Rectangle {
        return dimension;
    }

    public function set_dimension(value:Rectangle) {
        return this.dimension = value;
    }


}