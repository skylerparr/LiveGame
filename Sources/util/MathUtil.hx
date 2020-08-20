package util;
import geom.Point;
import world.WorldPoint;
@IgnoreCover
class MathUtil {

    private static var point: Point = new Point();

    public function new() {
    }

    /**
     * Convert degrees to radians.
     *
     * @param deg The number of degrees
     * @return The number of radians (between 0 and  2π)
     *
     */
    public static inline function degreesToRadians( deg: Float ): Float {
        return ( deg * Math.PI / 180.0 );
    }

    /**
     * Convert radians to degrees.
     *
     * @param rad The number of radians
     * @return The number of degrees (between 0 and 360)
     *
     */
    public static inline function radiansToDegrees( rad: Float): Float {
        return ( rad * 180.0 / Math.PI );
    }

    public static inline function roundUpToNearestPowerOf2( v: UInt ): UInt {
        v--;
        v |= v >> 1;
        v |= v >> 2;
        v |= v >> 4;
        v |= v >> 8;
        v |= v >> 16;
        v++;
        return v;
    }

    public static inline function getDirectionInDegrees(pointA: WorldPoint, pointB: WorldPoint): Float {
        var aX: Float = pointA.x;
        var aY: Float = pointA.z;
        var bX: Float = pointB.x;
        var bY: Float = pointB.z;
        point.x = aX;
        point.y = aY - Math.sqrt( Math.abs( bX - aX ) * Math.abs( bX - aX )
            + Math.abs( bY - aY ) * Math.abs( bY - aY ) );
        var radians: Float = (2 * Math.atan2( bY - point.y, bX - point.x ));
        return radiansToDegrees(radians);
    }

    public static inline function calculateDistance(pointA: WorldPoint, pointB: WorldPoint): Float {
        return Math.sqrt( Math.abs( (pointA.x - pointB.x) * (pointA.x - pointB.x) ) + Math.abs( (pointA.z - pointB.z) * (pointA.z - pointB.z) ) );
    }
}
