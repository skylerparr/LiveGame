package world.two;
class WorldPoint2D implements WorldPoint {

    @:isVar
    public var x(get, set):Float = 0;

    @:isVar
    public var y(get, set):Float = 0;

    @:isVar
    public var z(get, set):Float = 0;

    public function new(x:Float = 0, z:Float = 0) {
        this.x = x;
        this.z = z;
    }

    public function moveTo(point:WorldPoint):Void {
        x = point.x;
        z = point.z;
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
}
