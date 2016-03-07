package display.two;
class TwoDimDisplayNode implements DisplayNode {

    @:isVar
    public var x(get, set): Float;

    @:isVar
    public var y(get, set): Float;

    @:isVar
    public var z(get, set): Float;

    @:isVar
    public var width(get, set): Float;

    @:isVar
    public var height(get, set): Float;

    @:isVar
    public var depth(get, set): Float;

    @:isVar
    public var scaleX(get, set): Float;

    @:isVar
    public var scaleY(get, set): Float;

    @:isVar
    public var scaleZ(get, set): Float;

    @:isVar
    public var name(get, set): String;

    @:isVar
    public var parent(get, null):DisplayNodeContainer;

    @:isVar
    public var _private_parent(get, set):DisplayNodeContainer;

    public function get_x():Float {
        return x;
    }

    public function set_x(value:Float): Float {
        return this.x = value;
    }

    public function set_y(value:Float): Float {
        return this.y = value;
    }

    public function get_y():Float {
        return y;
    }

    public function set_z(value:Float): Float {
        return this.z = value;
    }

    public function get_z():Float {
        return z;
    }

    public function get_width():Float {
        return width;
    }

    public function set_width(value:Float): Float {
        return this.width = value;
    }

    public function set_height(value:Float): Float {
        return this.height = value;
    }

    public function get_height():Float {
        return height;
    }

    public function set_depth(value:Float): Float {
        return this.depth = value;
    }

    public function get_depth():Float {
        return depth;
    }

    public function get_scaleX():Float {
        return scaleX;
    }

    public function set_scaleX(value:Float): Float {
        return this.scaleX = value;
    }

    public function set_scaleY(value:Float): Float {
        return this.scaleY = value;
    }

    public function get_scaleY():Float {
        return scaleY;
    }

    public function set_scaleZ(value:Float): Float {
        return this.scaleZ = value;
    }

    public function get_scaleZ():Float {
        return scaleZ;
    }

    public function set_name(value:String): String {
        return this.name = value;
    }

    public function get_name():String {
        return name;
    }

    public function set_parent(value:DisplayNodeContainer) {
        return this.parent = value;
    }

    public function set__private_parent(value:DisplayNodeContainer) {
        return this._private_parent = value;
    }

    public function get__private_parent():DisplayNodeContainer {
        return _private_parent;
    }

    public function get_parent():DisplayNodeContainer {
        return _private_parent;
    }

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
        name = null;
    }

}
