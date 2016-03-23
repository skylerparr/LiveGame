package world.two;
import geom.Rectangle;
import geom.Point;
class Footprint2D implements Footprint {
    @:isVar
    public var registrationPoint(get, set):Point;

    @:isVar
    public var footprint(get, set):Rectangle;

    public function new() {
    }

    function get_registrationPoint():Point {
        return registrationPoint;
    }

    function set_registrationPoint(value:Point) {
        return this.registrationPoint = value;
    }

    function set_footprint(value:Rectangle) {
        return this.footprint = value;
    }

    function get_footprint():Rectangle {
        return footprint;
    }


}
