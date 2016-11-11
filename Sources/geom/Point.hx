package geom;
class Point {

    public var x: Float = 0;
    public var y: Float = 0;

    public function new(x:Float = 0, y:Float = 0) {
        this.x = x;
        this.y = y;
    }

    public static inline function distance(pt1: Point, pt2: Point): Float {
        var dx = pt1.x - pt2.x;
        var dy = pt1.y - pt2.y;
        return Math.sqrt (dx * dx + dy * dy);
    }

    @IgnoreCover
    public function toString(): String {
        return '${x},${y}';
    }
}
