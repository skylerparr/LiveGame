package world.two;
class Bounds2D implements Bounds {

    @:isVar
    public var x(get, set):Float = 0;

    @:isVar
    public var y(get, set):Float = 0;

    @:isVar
    public var z(get, set):Float = 0;

    @:isVar
    public var width(get, set):Float = 0;

    @:isVar
    public var height(get, set):Float = 0;

    @:isVar
    public var depth(get, set):Float = 0;

    public public function new(x: Float = 0, z:Float = 0, width:Float = 0, depth:Float = 0) {
        this.x = x;
        this.z = z;
        this.width = width;
        this.depth = depth;
    }

    public function get_x():Float {
        return x;
    }

    public function set_x(value:Float) {
        return this.x = value;
    }

    public function set_y(value:Float) {
        return 0;
    }

    public function get_y():Float {
        return 0;
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
        return 0;
    }

    public function get_height():Float {
        return 0;
    }

    public function set_depth(value:Float) {
        return this.depth = value;
    }

    public function get_depth():Float {
        return depth;
    }
}